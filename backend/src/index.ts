import express from 'express';
import authRouter from './routes/auth';
import taskRouter from './routes/task';

const app = express();

app.use(express.json())

app.use("/auth", authRouter)
app.use("/tasks", taskRouter)

app.get("/", (req, res) => {
    res.send("welcome to the app!!!")
})

app.listen(8000, () => {
    console.log("server on port 8000")
})