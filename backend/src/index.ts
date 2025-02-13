import express from 'express';

const app = express();

app.get("/", (req, res) => {
    res.send("welcome to the app")
})

app.listen(8000, () => {
    console.log("server on port 8000")
})