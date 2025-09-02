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
            a: {
              "border-radius": theme("borderRadius.sm"),
              "&:hover": {
                color: theme("colors.indigo.500"),
              },
              "&:focus": {
                color: theme("colors.indigo.500"),
                "outline-color": theme("colors.indigo.500"),
                "outline-width": theme("outlineWidth.2"),
                "outline-offset": theme("outlineOffset.0"),
                "outline-style": "dashed",
              },
            },
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
