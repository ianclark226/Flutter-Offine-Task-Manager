import { Router, Request, Response } from "express";
import { db } from "../db";
import { NewUser, users } from "../db/schema";
import { eq } from "drizzle-orm";
import bcryptjs from "bcryptjs"
import jwt from "jsonwebtoken"

const authRouter = Router()

interface SignUpBody {
    name: string
    email: string
    password: string
}

interface LoginBody {
    email: string
    password: string
}

authRouter.post("/signup", async (req: Request<{}, {}, SignUpBody>, res: Response) => {
    try {
        const { name, email, password } = req.body

        const existingUser = await db.select().from(users).where(eq(users.email, email))

        if(existingUser.length){
            res.status(400).json({ msg: "User with the same email already exists"})
            return
        }

        const hashedPassword = await bcryptjs.hash(password, 8)

        const newUser: NewUser = {
            name,
            email,
            password: hashedPassword,
        }

        const [user] = await db.insert(users).values(newUser).returning()
        res.status(201).json(user)
        
    } catch (error) {
        res.status(500).json({ error: error })
    }
})

authRouter.post("/login", async (req: Request<{}, {}, LoginBody>, res: Response) => {
    try {
        const { email, password } = req.body

        const [existingUser] = await db.select().from(users).where(eq(users.email, email))

        if(!existingUser){
            res.status(400).json({ msg: "User with the email does not exists"})
            return
        }

        const isMatch = await bcryptjs.compare(password, existingUser.password)

        if(!isMatch) {
            res.status(400).json({ msg: "Incorrect password"})
            return
        }

        const token = jwt.sign({id: existingUser.id}, "passwordKey")

        res.json({token, ...existingUser})
        
    } catch (error) {
        res.status(500).json({ error: error })
    }
})

authRouter.post("/tokenIsValid", async(req, res) => {
    try {

        const token = req.header("x-auth-token")

        if(!token) {
            res.json(false)
            return
        }

        const verified = jwt.verify(token, "passwordKey")

        if(!verified) {
            res.json(false)
            return
        } 

        const verifiedToken = verified as {id: string}

        const user = await db.select().from(users).where(eq(users.id, verifiedToken.id))

        if(!user) {
            res.json(false)
            return
        }

            res.json(true)
        
    } catch (error) {
        res.status(500).json(false)   
    }
})

authRouter.get("/", (req, res) => {
    res.send("hey there auth")
})

export default authRouter