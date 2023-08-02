const express = require("express");
var http = require("http");
// // const cors = require("cors");
const mysql = require("mysql2/promise");
let db = null;
const app = express();
const port = process.env.PORT || 5001;
var server = http.createServer(app);
var io = require("socket.io")(server);

function getRandomArbitrary(min, max) {
    return Math.random() * (max - min) + min;
}

//middlewere
app.use(express.json());
var clients = {};

io.on("connection", (socket) => {
    console.log("connected");
    console.log(socket.id, "has joined");
    socket.on("/signin", (id) => {
        // console.log(id);
        clients[id] = socket;
        // console.log(clients);
    });
    socket.on("message", (msg) => {
        console.log(msg);
        let targetId = msg.targetId;
        if (clients[targetId]) clients[targetId].emit("message", msg);
    });
});

server.listen(port, "0.0.0.0", () => {
    console.log("server started");
});


// let phoneValid = /^(\+7|7|8)?[\s\-]?\(?[0-9]{2}\)?[\s\-]?[0-9]{3}[\s\-]?[0-9]{2}[\s\-]?[0-9]{2}$/;
let usernameValid = /^[a-zA-Z0-9]+$/;
var emailValid = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
app.use(express.json());

var regStatus = '';


function isValid(username, phone, email, password) {

    if (username == null || username == '' || username.length == null) {
        regStatus = 'Enter Username';
        return false;
    } else if (!usernameValid.test(username)) {
        regStatus = "Don't use symbols";
        return false;
    } else {
        if (phone == null || phone == '' || phone.length == null) {
            regStatus = 'Enter phone number';
            return false;
        } else {
            if (email == null || email == '' || email.length == null) {
                regStatus = 'Enter email';
                return false;
            } else if (!emailValid.test(email)) {
                regStatus = 'Invalid email';
                return false;
            } else {
                if (password == null || password == '' || password.length == null) {
                    regStatus = 'Enter password';
                    return false;
                } else if (password.length < 8) {
                    regStatus = 'Password must be at least 8 characters long';
                    return false;
                } else if (password.length > 30) {
                    regStatus = 'Password must be less than 30 characters';
                    return false;
                } else {
                    regStatus = '';
                    return true;


                }
            }
        }
    }
}

app.post('/create-user', async(req, res, next) => {
    let username = req.body.username;
    let phone = req.body.phone;
    let email = req.body.email;
    let password = req.body.password;

    let row = await db.query("SELECT username FROM `Users` WHERE username = '" + username + "'");

    if (isValid(username, phone, email, password) == true) {
        if (row[0].length == 0) {
            await db.query("INSERT INTO `Users` (`username`, `Phone`, `Email`, `Password`) VALUES (?,?,?,?);", [username, phone, email, password]);
        } else { regStatus = "A user with this name exists" }
    }
    res.json({ status: regStatus });
    next();
});

// app.post('/create-chat', async (req, res, next) => {
//   let user_id = req.body.id;
//   let friend_id = req.body.friend_id;

//   await db.query("INSERT INTO `conversations` (`user_one`, `user_two`) VALUES (?,?);", [user_id, friend_id]);

//   res.json({ status: "OK" });
//   next();
// });

app.post('/create-chat', async(req, res, next) => {
    let user_id = req.body.id;
    let friend_id = req.body.friend_id;
    let c_name = req.body.c_name;

    let c_id = getRandomArbitrary(0, 18446744073709551611);

    let row = await db.query("SELECT c_id FROM `conversations` WHERE c_id = " + c_id);

    if (row[0].length == 0) {
        await db.query("INSERT INTO `conversations` (`c_id`, `c_name`) VALUES (?,?);", [c_id, c_name]);
        await db.query("INSERT INTO `party_conversation` (`c_id`, `user_id`) VALUES (?,?);", [c_id, user_id]);
        for (let i = 0; i < friend_id.length; i++) {
            await db.query("INSERT INTO `party_conversation` (`c_id`, `user_id`) VALUES (?,?);", [c_id, friend_id[i]]);
        }
    } else {
        c_id = getRandomArbitrary(0, 18446744073709551611);
    }
    res.json({ status: "OK" });

    next();
});


app.post('/add-to-friend', async(req, res, next) => {
    let user_id = req.body.user_id;
    let friend_id = req.body.friend_id;

    await db.query("INSERT INTO friends (friend_one,friend_two) VALUES(?,?);", [user_id, friend_id]);

    res.json({ status: "OK" });
    next();
});

app.post('/add-message', async(req, res, next) => {
    let content = req.body.content;
    let from_id = req.body.from_id;
    // let to_id = req.body.to_id;
    let c_id = req.body.c_id;

    await db.query("INSERT INTO Messages (content,From_Id,c_id) VALUES(?,?,?);", [content, from_id, c_id]);

    res.json({ status: "OK" });
    next();
});



app.post('/confirm-friend-req', async(req, res, next) => {
    let user_id = req.body.user_id;
    let friend_id = req.body.friend_id;

    await db.query("UPDATE friends SET status='1' WHERE (friend_one=" + user_id + " OR friend_two=" + user_id + ") AND (friend_one=" + friend_id + " OR friend_two=" + friend_id + ");");

    res.json({ status: "OK" });
    next();
});

app.post('/remove-friend', async(req, res, next) => {
    let user_id = req.body.user_id;
    let friend_id = req.body.friend_id;

    await db.query("DELETE FROM friends WHERE (friend_one= ? AND friend_two= ?) OR (friend_one= ? AND friend_two= ?);", [user_id, friend_id, friend_id, user_id]);

    res.json({ status: "OK" });
    next();
});

// app.post('/search-user', async (req, res, next) => {
//   user_id = req.body.id;

//   const [rows] = await db.query("SELECT id, username, phone, email, password FROM users WHERE id = " + user_id);

//   res.json(rows);
//   next();
// });
app.post('/search-user', async(req, res, next) => {
    username = req.body.username;

    const [rows] = await db.query("SELECT id, username, phone, email, password FROM users WHERE username = '" + username + "'");

    res.json(rows);
    next();
});

app.post('/users', async(req, res, next) => {
    user_id = req.body.id;

    const [rows] = await db.query("SELECT id, username, phone, email, password FROM users WHERE id != " + user_id);

    res.json(rows);
    next();
});

app.post('/friends', async(req, res, next) => {
    user_id = req.body.id;

    const [rows] = await db.query("SELECT U.id, U.username FROM users U, friends F WHERE F.status='1' AND ((F.friend_one = " + user_id + "  AND F.friend_two = U.id )OR (F.friend_two= " + user_id + " AND F.friend_one= U.id) ) ;");

    res.json(rows);
    next();
});
app.post('/friends2', async(req, res, next) => {
    user_id = req.body.id;

    const [rows] = await db.query("SELECT U.id, U.username, U.phone, U.email, U.password FROM users U, friends F WHERE F.status='1' AND ((F.friend_one = " + user_id + "  AND F.friend_two = U.id )OR (F.friend_two= " + user_id + " AND F.friend_one= U.id) ) ;");

    res.json(rows);
    next();
});



app.post('/chats', async(req, res, next) => {
    user_id = req.body.id;


    const [rows] = await db.query("SELECT U.id, C.c_name, C.c_id FROM users U,conversations C, party_conversation PC WHERE " +
        "(PC.user_id = " + user_id + " AND PC.user_id = U.id)" +
        "AND" +
        "(PC.user_id = " + user_id + " AND PC.c_id = C.c_id)" +
        "ORDER BY C.c_id DESC");
    console.log(rows);
    //SELECT U.id, C.c_name, C.c_id FROM users U,conversations C, party_conversation PC WHERE 
    // (PC.user_id = 2 AND PC.user_id = U.id)
    // AND
    // (PC.user_id = 2 AND PC.c_id = C.c_id)
    // ORDER BY C.c_id DESC

    // const [rows] = await db.query("SELECT U.id, U.username,C.c_id FROM users U,conversations C WHERE " +
    //   "(C.user_one = " + user_id + " AND C.user_two = U.id)" +
    //   "OR" +
    //   "(C.user_two = " + user_id + " AND C.user_one = U.id)" +
    //   "AND" +
    //   "(C.user_one = " + user_id + " OR C.user_two = " + user_id + ") ORDER BY C.c_id DESC");

    res.json(rows);
    next();
});

app.post('/messages', async(req, res, next) => {
    let c_id = req.body.c_id;

    const [rows] = await db.query("SELECT M.content, M.from_id, M.c_id FROM Messages M WHERE M.c_id = " + c_id);
    console.log(rows);
    res.json(rows);
    next();
});

app.post('/party', async(req, res, next) => {
    let user_id = req.body.user_id;
    let c_id = req.body.c_id;

    const [rows] = await db.query("SELECT U.id FROM users U,conversations C, party_conversation PC WHERE" +
        "(PC.user_id != " + user_id + " AND PC.user_id = U.id)" +
        "AND" +
        "(PC.c_id = " + c_id + " AND PC.c_id = C.c_id)" +
        "ORDER BY C.c_id DESC");
    console.log(rows);
    res.json(rows);
    next();
});

app.post('/login', async(req, res, next) => {
    let username = req.body.username;
    let password = req.body.password;
    const [rows] = await db.query("SELECT id, username, phone, email, password FROM users WHERE username = ? AND password = ?;", [username, password]);
    res.json(rows);
    next();
});

app.post('/user-profile', async(req, res, next) => {
    let user_id = req.body.user_id;
    let friend_id = req.body.friend_id;
    const [rows] = await db.query("SELECT friend_one,friend_two,status FROM friends WHERE (friend_one=" + user_id + " OR friend_two=" + user_id + ") AND (friend_one=" + friend_id + " OR friend_two=" + friend_id + ")");

    if (rows.length == 0) {
        res.json(null);
    } else {
        res.json(rows);
    }
    next();
});

async function main() {
    db = await mysql.createConnection({
        host: "127.0.0.1",
        user: "root",
        password: "",
        database: "messenger",
        timezone: "+00:00",
        charset: "utf8mb4_general_ci",
    });

    app.listen(8001);
}

main();