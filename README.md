🎉 New Free Script: Permanent ID Assignment to Combat Troll Players! 🎉

We are excited to share with you a free script that will enhance security and control on your server! This script was specifically created to capture troll players who disrupt the server's experience. Now, you can assign a unique permanent ID to every player that connects, allowing you to identify players who disconnect and rejoin under a different name or account.

Main Features:
🔒 Permanent ID for Players:

Each player will receive a unique 4-character ID when they connect. This ID will always be associated with their account, even if they disconnect and reconnect.
🛡️ Full Control Over Disconnects:

If a player disconnects and then reconnects with a different name, you’ll be able to see who they really are thanks to their permanent ID. This will help you catch troll players trying to deceive the system!
📢 Discord Notifications:

Every time a player receives their new ID, a message will be automatically sent to your Discord channel. Keep your community informed and take action quickly against problematic players.
✅ Unique ID Verification:

The system checks if the generated ID already exists, ensuring each player gets a unique ID. If the ID is already in use, a new one will be generated.
⚙️ Easy to Install:

You just need to configure the Discord Webhook, and the script installs quickly without complications. It’s very easy to integrate into your server!
💻 Database Compatibility:

The script uses oxmysql (also compatible with mysql-async) to store the data efficiently and securely.
How It Works:
The script assigns a random ID to each player, which is stored in the database. If the player disconnects and reconnects, the ID is checked to ensure it stays consistent, letting you know if someone is trying to create fake accounts. Additionally, the ID will be visible to the player, ensuring they always know what their ID is.

🔢 Possible Unique IDs:

Since the generated ID is 4 letters long, the maximum number of unique IDs that could be generated without repeating would be 456,976 possible combinations. This is because there are 26 letters in the alphabet, and with 4 characters, you get 26^4 possible combinations.