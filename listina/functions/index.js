const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const database = admin.firestore();
exports.sendNotification = functions.pubsub.schedule('* * * * *').onRun(async (context) => {

    const query = await database.collection("notifications")
        .where("whenToNotify", '<=', admin.firestore.Timestamp.now())
        .where("notificationSent", "==", false).get();

    query.forEach(async snapshot => {
        sendNotification(snapshot.data().token);
        await database.doc('notifications/' + snapshot.data().token).update({
            "notificationSent": true,
        });
    });
    function sendNotification(androidNotificationToken) {
        let title = "Hai, Lets Shopping";
        let body = "Check your shopping trip now!";
        const message = {
            notification: { title: title, body: body },
            token: androidNotificationToken,
            data: { click_action: 'FLUTTER_NOTIFICATION_CLICK' }
        };
        admin.messaging().send(message).then(response => {
            return console.log("Successful Message Sent");
        }).catch(error => {
            return console.log("Error Sending Message");
        });
    }
    return console.log('End Of Function');
});