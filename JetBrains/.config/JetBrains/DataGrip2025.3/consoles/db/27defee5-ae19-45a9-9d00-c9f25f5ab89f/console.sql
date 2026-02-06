ALTER TABLE "accounts_payable" DROP CONSTRAINT "unique_account_payable";--> statement-breakpoint
ALTER TABLE "accounts_payable" ADD CONSTRAINT "unique_account_payable" UNIQUE("store_id","payable_code","duplicate","document");
