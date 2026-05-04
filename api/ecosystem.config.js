module.exports = {
  apps: [
    {
      name: 'api-pi5',
      script: 'dist/app.js',
      cwd: '/home/eduardo/DSM-P5-G02-2026-01/api',
      env: {
        NODE_ENV: 'production',
      },
      env_file: '.env',        // carrega seu .env automaticamente
    },
  ],
};