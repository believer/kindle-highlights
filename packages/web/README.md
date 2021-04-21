# web

## Run Project

```sh
npm install
npm start
# in another tab
npm run server
```

When both processes are running, open a browser at http://localhost:3000

## Build for Production

```sh
npm run clean
npm run build
npm run webpack:production
```

This will replace the development artifact `build/Index.js` for an optimized
version as well as copy `public/index.html` into `build/`. You can then deploy the
contents of the `build` directory (`index.html` and `Index.js`).

If you make use of routing (via `ReasonReact.Router` or similar logic) ensure
that server-side routing handles your routes or that 404's are directed back to
`index.html` (which is how the dev server is set up).

**To enable dead code elimination**, change `bsconfig.json`'s `package-specs`
`module` from `"commonjs"` to `"es6"`. Then re-run the above 2 commands. This
will allow Webpack to remove unused code.
'

## Build to Now

This project includes building straight to [Now](https://zeit.co/) after Travis has validated
tests and created a release. There are some steps that need to be taken to enable the setup.

1. Get a token from your [Now dashboard](https://zeit.co/account/tokens)
1. Set the token as `NOW_TOKEN` in Travis
1. Uncomment the Now build steps in `.travis.yml`
1. Add `now-build` to `package.json` scripts. Now runs this script during it build process:

```
"now-build": "npm run build && npm run webpack:production"
```
