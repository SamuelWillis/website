/** @type {import('tailwindcss').Config} */
module.exports = {
  theme: {
    extend: {
      colors: {
        brand: "#FD4F00",
      },
      typography: (theme) => ({
        DEFAULT: {
          css: {
            pre: {
              "background-color": "#F0F0F0",
              color: "currentcolor",
            },
            code: null,
            "code::before": null,
            "code::after": null,
            "pre code": null,
            "pre code::before": null,
            "pre code::after": null,
          },
        },
      }),
    },
  },
};
