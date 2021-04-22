module.exports = {
  testEnvironment: 'node',
  testPathIgnorePatterns: ['node_modules', 'out'],
  watchPlugins: [
    'jest-watch-typeahead/filename',
    'jest-watch-typeahead/testname',
  ],
}
