import { Router } from "express";

const authRouter = Router()

authRouter.get("/", (req, res) => {
    res.send("hey there auth")
})

export default authRouter