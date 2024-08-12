DO $$ BEGIN
 CREATE TYPE "public"."type" AS ENUM('email', 'google', 'github');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "accounts" (
	"id" serial PRIMARY KEY NOT NULL,
	"userId" serial NOT NULL,
	"accountType" "type" NOT NULL,
	"githubId" text,
	"googleId" text,
	"password" text,
	"salt" text,
	CONSTRAINT "accounts_githubId_unique" UNIQUE("githubId"),
	CONSTRAINT "accounts_googleId_unique" UNIQUE("googleId")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "magic_links" (
	"id" serial PRIMARY KEY NOT NULL,
	"email" text NOT NULL,
	"token" text,
	"tokenExpiresAt" timestamp,
	CONSTRAINT "magic_links_email_unique" UNIQUE("email")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "profile" (
	"id" serial PRIMARY KEY NOT NULL,
	"userId" serial NOT NULL,
	"displayName" text,
	"imageId" text,
	"image" text,
	"bio" text DEFAULT '' NOT NULL,
	CONSTRAINT "profile_userId_unique" UNIQUE("userId")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "reset_tokens" (
	"id" serial PRIMARY KEY NOT NULL,
	"userId" serial NOT NULL,
	"token" text,
	"tokenExpiresAt" timestamp,
	CONSTRAINT "reset_tokens_userId_unique" UNIQUE("userId")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "session" (
	"id" text PRIMARY KEY NOT NULL,
	"userId" serial NOT NULL,
	"expires_at" timestamp with time zone NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "user" (
	"id" serial PRIMARY KEY NOT NULL,
	"email" text,
	"emailVerified" timestamp,
	CONSTRAINT "user_email_unique" UNIQUE("email")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "verify_email_tokens" (
	"id" serial PRIMARY KEY NOT NULL,
	"userId" serial NOT NULL,
	"token" text,
	"tokenExpiresAt" timestamp,
	CONSTRAINT "verify_email_tokens_userId_unique" UNIQUE("userId")
);
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "accounts" ADD CONSTRAINT "accounts_userId_user_id_fk" FOREIGN KEY ("userId") REFERENCES "public"."user"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "profile" ADD CONSTRAINT "profile_userId_user_id_fk" FOREIGN KEY ("userId") REFERENCES "public"."user"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "reset_tokens" ADD CONSTRAINT "reset_tokens_userId_user_id_fk" FOREIGN KEY ("userId") REFERENCES "public"."user"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "session" ADD CONSTRAINT "session_userId_user_id_fk" FOREIGN KEY ("userId") REFERENCES "public"."user"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "verify_email_tokens" ADD CONSTRAINT "verify_email_tokens_userId_user_id_fk" FOREIGN KEY ("userId") REFERENCES "public"."user"("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
