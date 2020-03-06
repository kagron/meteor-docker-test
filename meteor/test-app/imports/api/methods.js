import { Tasks } from "./tasks";

Meteor.methods({
    '/test'() {
        console.log(Meteor.settings);
        Tasks.insert({
            text: 'Hello world from meteor methodds',
            createdAt: new Date()
        });
        const tasks = Tasks.find({}).fetch();
        console.log({ tasks });
        return tasks;
    }
});