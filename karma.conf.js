module.exports = function (config) {
  config.set({
    frameworks: ['jasmine', '@angular-devkit/build-angular'],

    // ... other configuration ...

    browsers: ['Chrome', 'ChromeHeadless', 'ChromeHeadlessCI'],
    customLaunchers: {
      ChromeHeadlessCI: {
        base: 'ChromeHeadless',
        flags: ['--no-sandbox']
      }
    },

    plugins: [
      require('karma-jasmine'),
      require('karma-chrome-launcher'),
      require('@angular-devkit/build-angular/plugins/karma')
      // ... other plugins ...
    ],

    // ... other configuration ...
  });
};