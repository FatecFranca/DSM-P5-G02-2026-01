import dotenv from "dotenv";
import { Request, Response, NextFunction } from "express";
import jwt, { JwtPayload, SignOptions, TokenExpiredError } from "jsonwebtoken";
import { prisma } from "../../lib/prisma";

dotenv.config();

const JWT_SECRET = process.env.JWT_SECRET || "your-secret-key";
const JWT_EXPIRES_IN = "30m" as const;

if (!process.env.DATABASE_URL) throw new Error("DATABASE_URL nao configurada");
if (JWT_SECRET === "your-secret-key") console.warn("JWT_SECRET padrao - configure para producao!");

const signOptions: SignOptions = { expiresIn: JWT_EXPIRES_IN };

const parseDurationToMs = (value: string): number => {
  const matched = value.match(/^(\d+)([smhd])$/i);
  if (!matched) return 15 * 60 * 1000;

  const amount = Number(matched[1]);
  const unit = matched[2].toLowerCase();

  if (unit === "s") return amount * 1000;
  if (unit === "m") return amount * 60 * 1000;
  if (unit === "h") return amount * 60 * 60 * 1000;
  return amount * 24 * 60 * 60 * 1000;
};

const SESSION_IDLE_TIMEOUT_MS = parseDurationToMs(JWT_EXPIRES_IN);
const lastActivityByToken = new Map<string, number>();

const touchSession = (token: string, now: number) => {
  lastActivityByToken.set(token, now);
};

const hasRecentActivity = (token: string, now: number): boolean => {
  const lastActivity = lastActivityByToken.get(token);
  if (!lastActivity) return false;
  return now - lastActivity <= SESSION_IDLE_TIMEOUT_MS;
};

const pruneInactiveSessions = (now: number) => {
  for (const [cachedToken, lastActivity] of lastActivityByToken.entries()) {
    if (now - lastActivity > SESSION_IDLE_TIMEOUT_MS) {
      lastActivityByToken.delete(cachedToken);
    }
  }
};

export const generateToken = (payload: object): string => jwt.sign(payload, JWT_SECRET, signOptions);
export const verifyToken = (token: string): JwtPayload => jwt.verify(token, JWT_SECRET) as JwtPayload;

export const authMiddleware = async (
  req: Request & { user?: any },
  res: Response,
  next: NextFunction
) => {
  const authHeader = req.headers.authorization;
  const tokenFromBearer = authHeader?.startsWith("Bearer ") ? authHeader.slice(7) : undefined;
  const tokenFromCustomHeader = typeof req.headers["x-access-token"] === "string" ? req.headers["x-access-token"] : undefined;
  const token = tokenFromBearer || tokenFromCustomHeader;

  if (!token) {
    return res.status(401).json({ success: false, message: "Token nao fornecido" });
  }

  const now = Date.now();
  let idUsuario: number | undefined;

  try {
    const decoded = verifyToken(token) as { id_usuario: number };
    idUsuario = decoded.id_usuario;
  } catch (error) {
    if (error instanceof TokenExpiredError) {
      try {
        const decodedWithoutExp = jwt.verify(token, JWT_SECRET, {
          ignoreExpiration: true,
        }) as JwtPayload & { id_usuario?: number };

        if (decodedWithoutExp.id_usuario && hasRecentActivity(token, now)) {
          idUsuario = decodedWithoutExp.id_usuario;
        }
      } catch {
        return res.status(401).json({ success: false, message: "Token invalido ou expirado" });
      }
    }

    if (!idUsuario) {
      return res.status(401).json({ success: false, message: "Token invalido ou expirado" });
    }
  }

  try {
    const user = await prisma.tb_usuario.findUnique({
      where: { id_usuario: idUsuario },
      include: { tb_cargos: true },
    });

    if (!user || !user.ativo) {
      return res.status(401).json({ success: false, message: "Usuario invalido ou inativo" });
    }

    req.user = {
      id_usuario: user.id_usuario,
      id_cargo: user.id_cargo,
      id_organizacao: user.id_organizacao,
      login: user.login,
    };

    // Sliding expiration por atividade: mantem sessao ativa enquanto houver uso continuo.
    touchSession(token, now);

    const renewedToken = generateToken({ id_usuario: user.id_usuario });
    touchSession(renewedToken, now);

    res.setHeader("Authorization", `Bearer ${renewedToken}`);
    res.setHeader("x-access-token", renewedToken);

    pruneInactiveSessions(now);

    next();
  } catch {
    return res.status(500).json({ success: false, message: "Erro interno na autenticacao" });
  }
};
