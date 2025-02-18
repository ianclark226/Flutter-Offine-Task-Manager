import { NextFunction, Request, Response } from "express"
import { UUID } from "crypto"
import jwt from "jsonwebtoken"
import { db } from "../db"
import { users } from "../db/schema"
import { eq } from "drizzle-orm";
import { error } from "console"

export interface AuthRequest extends Request {
    user?: UUID
    token?: string

}
export const auth = async(req: AuthRequest, res: Response, next: NextFunction) => {
    try {
    
            const token = req.header("x-auth-token")
    
            if(!token) {
                res.status(401).json({error: "No auth Token, access denied"})
                return
            }
    
            const verified = jwt.verify(token, "passwordKey")
    
            if(!verified) {
                res.status(401).json({error: "Token verification failed"})
                return
            } 
    
            // get the user data is token is true
            const verifiedToken = verified as {id: UUID}
    
            const user = await db.select().from(users).where(eq(users.id, verifiedToken.id))
    
            if(!user) {
                res.json({error: "User not found"})
                return
            }

            req.user = verifiedToken.id
            req.token = token
    
                next()
            
        } catch (error) {
            res.status(500).json({error: error})   
        }
}