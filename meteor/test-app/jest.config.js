module.exports = {
    setupFiles: ['<rootDir>/.jest/register-context.js'],
    modulePaths: [ '<rootDir>/', '<rootDir>/node_modules/', '<rootDir>/node_modules/jest-meteor-stubs/lib/' ],
    testEnvironment: 'node',
    "setupFilesAfterEnv": ["<rootDir>.jest/enzyme-setup.js"],
    "snapshotSerializers": ["enzyme-to-json/serializer"],
    transform: {
        // '^.+\\.tsx?$': 'ts-jest',
        '^.+\\.jsx?$': 'babel-jest'
    },
    testMatch: [
        "**/tests/**/*.[jt]s?(x)",
        "**/?(*.)+(spec|test).[jt]s?(x)",
        "**/__tests__/**/*.[jt]s?(x)",
        "<rootDir>/tests/*.js"
    ]
};