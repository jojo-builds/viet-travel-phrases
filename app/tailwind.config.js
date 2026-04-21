/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: 'class',
  content: ['./app/**/*.{js,jsx,ts,tsx}', './components/**/*.{js,jsx,ts,tsx}'],
  presets: [require('nativewind/preset')],
  theme: {
    extend: {
      colors: {
        primary: '#D97745',
        'primary-dark': '#BC5F30',
        premium: '#1F6F78',
        'premium-soft': '#E4F3F4',
        background: '#F5F1EA',
        surface: '#FFFFFF',
        'surface-soft': '#F8F3EC',
        'accent-soft': '#FFF1E6',
        'text-primary': '#1F2937',
        'text-secondary': '#475569',
        vietnamese: '#162033',
        romanized: '#C55B2A',
        english: '#475569',
        success: '#2F855A',
        border: '#E5DED3',
        body: '#334155',
        caption: '#64748B',
      },
    },
  },
  plugins: [],
};
