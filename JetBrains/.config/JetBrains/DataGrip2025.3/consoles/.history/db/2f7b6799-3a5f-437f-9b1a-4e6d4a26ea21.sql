select * from movements order by created_at desc;
;-- -. . -..- - / . -. - .-. -.--
select * from movements order by updated_at desc;
;-- -. . -..- - / . -. - .-. -.--
select * from movements order by updated_at asc;
;-- -. . -..- - / . -. - .-. -.--
select * from movements order by updated_at DESC;
;-- -. . -..- - / . -. - .-. -.--
select * from movements order by updated_at ASC;
;-- -. . -..- - / . -. - .-. -.--
select * from movements order by created_at ASC;
;-- -. . -..- - / . -. - .-. -.--
select count(*) from movements;
;-- -. . -..- - / . -. - .-. -.--
ALTER TABLE "movements" ADD COLUMN "sync_key" varchar(64) NOT NULL;
;-- -. . -..- - / . -. - .-. -.--
ALTER TABLE "movements" ADD CONSTRAINT "movements_sync_key_unique" UNIQUE("sync_key");
;-- -. . -..- - / . -. - .-. -.--
delete  from movements;
;-- -. . -..- - / . -. - .-. -.--
select *
from movements;
;-- -. . -..- - / . -. - .-. -.--
select *;
;-- -. . -..- - / . -. - .-. -.--
ALTER TABLE "movements" DROP CONSTRAINT "movements_sync_key_unique";
;-- -. . -..- - / . -. - .-. -.--
ALTER TABLE "movements" DROP CONSTRAINT "unique_movement_per_day";
;-- -. . -..- - / . -. - .-. -.--
ALTER TABLE "movements" DROP COLUMN "sync_key";
;-- -. . -..- - / . -. - .-. -.--
ALTER TABLE "movements" ADD CONSTRAINT "unique_movement_per_day" UNIQUE("reference","store","product","timestamp_date","color","brand","type","operation","size","class","product_store");
;-- -. . -..- - / . -. - .-. -.--
delete from movements;
;-- -. . -..- - / . -. - .-. -.--
select count(*)
from movements;
;-- -. . -..- - / . -. - .-. -.--
select * from movements;
;-- -. . -..- - / . -. - .-. -.--
CREATE TABLE "accounts_payable" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"store_id" uuid,
	"destination_store_id" uuid,
	"payment_store_id" uuid,
	"supplier_id" uuid,
	"payable_code" varchar(45) NOT NULL,
	"supplier_store_id" integer,
	"duplicate" varchar(50),
	"duplicate_number" varchar(20),
	"history" varchar(255),
	"invoice" varchar(50),
	"document" varchar(50),
	"check_number" varchar(50),
	"launch_date" timestamp,
	"issue_date" timestamp,
	"due_date" timestamp,
	"payment_date" timestamp,
	"last_update_date" timestamp,
	"nfe_sent_date" timestamp,
	"entry_issue_date" timestamp,
	"payment_location" varchar(255),
	"payment_value" numeric(15, 3),
	"bank_data" varchar(255),
	"interest" numeric(15, 3),
	"fine" numeric(15, 3),
	"anticipated_value" numeric(15, 3),
	"total" numeric(15, 3),
	"installments_value" numeric(15, 3),
	"order_code" integer,
	"order_store_id" integer,
	"order_destination_store_id" integer,
	"installments_count" integer,
	"punctuality_discount" numeric(15, 3),
	"punctuality_discount_type" varchar(50),
	"commercial_discount" numeric(15, 3),
	"discount" numeric(15, 3),
	"supplier_cnpj" varchar(35),
	"account_store_id" integer,
	"account_code" integer,
	"account_description" varchar(255),
	"account_type" varchar(20),
	"account_destination_store_code" integer,
	"payment_type_store_id" integer,
	"payment_type_code" integer,
	"payment_type_description" varchar(255),
	"forecast_code" integer,
	"forecast_description" varchar(255),
	"payment_account_store_id" integer,
	"payment_account_code" integer,
	"payment_account_description" varchar(255),
	"payment_account_type" varchar(20),
	"payment_account_destination_store_code" integer,
	"created_at" timestamp DEFAULT now(),
	"updated_at" timestamp DEFAULT now(),
	CONSTRAINT "unique_account_payable" UNIQUE("store_id","payable_code")
);
;-- -. . -..- - / . -. - .-. -.--
ALTER TABLE "accounts_payable" ADD CONSTRAINT "accounts_payable_store_id_stores_id_fk" FOREIGN KEY ("store_id") REFERENCES "public"."stores"("id") ON DELETE no action ON UPDATE no action;
;-- -. . -..- - / . -. - .-. -.--
ALTER TABLE "accounts_payable" ADD CONSTRAINT "accounts_payable_destination_store_id_stores_id_fk" FOREIGN KEY ("destination_store_id") REFERENCES "public"."stores"("id") ON DELETE no action ON UPDATE no action;
;-- -. . -..- - / . -. - .-. -.--
ALTER TABLE "accounts_payable" ADD CONSTRAINT "accounts_payable_payment_store_id_stores_id_fk" FOREIGN KEY ("payment_store_id") REFERENCES "public"."stores"("id") ON DELETE no action ON UPDATE no action;
;-- -. . -..- - / . -. - .-. -.--
ALTER TABLE "accounts_payable" ADD CONSTRAINT "accounts_payable_supplier_id_suppliers_id_fk" FOREIGN KEY ("supplier_id") REFERENCES "public"."suppliers"("id") ON DELETE no action ON UPDATE no action;
;-- -. . -..- - / . -. - .-. -.--
CREATE INDEX "accounts_payable_store_idx" ON "accounts_payable" USING btree ("store_id","payable_code");
;-- -. . -..- - / . -. - .-. -.--
CREATE INDEX "accounts_payable_supplier_idx" ON "accounts_payable" USING btree ("supplier_id");
;-- -. . -..- - / . -. - .-. -.--
CREATE INDEX "accounts_payable_due_date_idx" ON "accounts_payable" USING btree ("due_date");
;-- -. . -..- - / . -. - .-. -.--
ALTER TABLE "accounts_payable" DROP CONSTRAINT "unique_account_payable";
;-- -. . -..- - / . -. - .-. -.--
ALTER TABLE "accounts_payable" ADD CONSTRAINT "unique_account_payable" UNIQUE("store_id","payable_code","duplicate","document");
;-- -. . -..- - / . -. - .-. -.--
ALTER TABLE "accounts_payable" ALTER COLUMN "duplicate_number" SET DATA TYPE varchar(45);
;-- -. . -..- - / . -. - .-. -.--
ALTER TABLE "accounts_payable" ALTER COLUMN "account_type" SET DATA TYPE varchar(45);
;-- -. . -..- - / . -. - .-. -.--
ALTER TABLE "accounts_payable" ALTER COLUMN "payment_account_type" SET DATA TYPE varchar(45);
;-- -. . -..- - / . -. - .-. -.--
ALTER TABLE "sales" ADD COLUMN "sale_type_desc" varchar(45) DEFAULT '';
;-- -. . -..- - / . -. - .-. -.--
select * from accounts_payable;
;-- -. . -..- - / . -. - .-. -.--
select * from movements order by timestamp_date desc;
;-- -. . -..- - / . -. - .-. -.--
elect * from movements order by timestamp_date desc;
;-- -. . -..- - / . -. - .-. -.--
select * from sales s order by s.issue_date desc;
;-- -. . -..- - / . -. - .-. -.--
select * from sales s order by s.issue_date desc limit 10;