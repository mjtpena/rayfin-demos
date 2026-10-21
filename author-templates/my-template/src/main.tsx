import { createRoot } from 'react-dom/client';

import { appConfig } from '@/appConfig';
import App from '@/App';
import { AuthProvider } from '@/hooks/AuthContext';
import { bootstrapAuth } from '@/services/bootstrap';

import './main.css';

document.title = appConfig.title;

const authService = await bootstrapAuth();

createRoot(document.getElementById('root')!).render(
  <AuthProvider authService={authService}>
    <App />
  </AuthProvider>
);
