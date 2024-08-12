import {
  timestamp,
  text,
  pgEnum,
  serial,
  boolean,
  pgTable,
  integer,
} from "drizzle-orm/pg-core";
export const accountTypeEnum = pgEnum("type", ["email", "google", "github"]);

export const users = pgTable("user", {
  id: serial("id").primaryKey(),
  email: text("email").unique(),
  emailVerified: timestamp("emailVerified", { mode: "date" }),
});

export const accounts = pgTable("accounts", {
  id: serial("id").primaryKey(),
  userId: serial("userId")
    .notNull()
    .references(() => users.id, { onDelete: "cascade" }),
  accountType: accountTypeEnum("accountType").notNull(),
  githubId: text("githubId").unique(),
  googleId: text("googleId").unique(),
  password: text("password"),
  salt: text("salt"),
});

export const magicLinks = pgTable("magic_links", {
  id: serial("id").primaryKey(),
  email: text("email").notNull().unique(),
  token: text("token"),
  tokenExpiresAt: timestamp("tokenExpiresAt", { mode: "date" }),
});

export const resetTokens = pgTable("reset_tokens", {
  id: serial("id").primaryKey(),
  userId: serial("userId")
    .notNull()
    .references(() => users.id, { onDelete: "cascade" })
    .unique(),
  token: text("token"),
  tokenExpiresAt: timestamp("tokenExpiresAt", { mode: "date" }),
});

export const verifyEmailTokens = pgTable("verify_email_tokens", {
  id: serial("id").primaryKey(),
  userId: serial("userId")
    .notNull()
    .references(() => users.id, { onDelete: "cascade" })
    .unique(),
  token: text("token"),
  tokenExpiresAt: timestamp("tokenExpiresAt", { mode: "date" }),
});

export const profiles = pgTable("profile", {
  id: serial("id").primaryKey(),
  userId: serial("userId")
    .notNull()
    .references(() => users.id, { onDelete: "cascade" })
    .unique(),
  displayName: text("displayName"),
  imageId: text("imageId"),
  image: text("image"),
  bio: text("bio").notNull().default(""),
});

export const sessions = pgTable("session", {
  id: text("id").primaryKey(),
  userId: serial("userId")
    .notNull()
    .references(() => users.id, { onDelete: "cascade" }),
  expiresAt: timestamp("expires_at", {
    withTimezone: true,
    mode: "date",
  }).notNull(),
});
export type User = typeof users.$inferSelect;
export type Profile = typeof profiles.$inferSelect;
