/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ['./app/**/*.{js,jsx,ts,tsx}', './components/**/*.{js,jsx,ts,tsx}'],
  theme: {
    extend: {
      colors: {
        primary: '#FF6B35',
        'primary-dark': '#E55A2B',
        background: '#FAFAF8',
        surface: '#FFFFFF',
        'text-primary': '#1A1A2E',
        'text-secondary': '#6B7280',
        vietnamese: '#1A1A2E',
        romanized: '#FF6B35',
        english: '#6B7280',
        success: '#10B981',
        border: '#E5E7EB',
        body: '#374151',
        caption: '#9CA3AF',
      },
    },
  },
  plugins: [],
};
