# TO START

1.  Clone repository
2.  `$ docker-compose up`
3.  Application will be running on http://localhost:3000/

To add a new to do:

1.  `$ docker-compose exec meteor bash`
2.  Inside the container run: `# meteor shell`
3.  Inside meteor shell run: `>Meteor.call('/test');`
4.  You will have a new to do
