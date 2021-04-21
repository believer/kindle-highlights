module.exports = {
  mode: "jit",
  purge: ["./src/**/*.bs.js"],
  darkMode: "media",
  theme: {
    extend: {
      zIndex: {
        "-10": "-10",
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
};
