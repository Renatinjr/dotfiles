ALTER TABLE "accounts_payable" ADD CONSTRAINT "unique_account_payable" UNIQUE("store_id","payable_code","duplicate");
;-- -. . -..- - / . -. - .-. -.--
select * from accounts_payable;
;-- -. . -..- - / . -. - .-. -.--
ALTER TABLE "accounts_payable" DROP CONSTRAINT "unique_account_payable";
;-- -. . -..- - / . -. - .-. -.--
ALTER TABLE "accounts_payable" ADD CONSTRAINT "unique_account_payable" UNIQUE("store_id","payable_code","duplicate","document");