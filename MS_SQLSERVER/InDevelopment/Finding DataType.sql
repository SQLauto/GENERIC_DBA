SET STATISTICS IO ON;
SELECT  CAST('<XMLRoot><RowData>'
             + REPLACE(
               (
                   SELECT   '__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+' AS "*"
                   FOR XML PATH('')
               )
             , ','
             , '</RowData><RowData>'
                      ) + '</RowData></XMLRoot>' AS XML) AS "x";

SELECT  '__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+' AS "*"
FOR XML PATH('RowData');
SET STATISTICS IO OFF;




DECLARE @query NVARCHAR(MAX) = N'SELECT   ''__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+'' AS "*"
                   FOR XML PATH(''RowData'')';
EXEC sp_describe_first_result_set @query, NULL, 0;
GO

DECLARE @query NVARCHAR(MAX) = N'SELECT 1';
EXEC sp_describe_first_result_set @query, NULL, 0;
GO

DECLARE @query NVARCHAR(MAX) = N'SELECT ''__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+''';
EXEC sp_describe_first_result_set @query, NULL, 0;
GO

DECLARE @query NVARCHAR(MAX) =	N'SELECT  CAST(''<XMLRoot><RowData>''
             + REPLACE(
               (
                   SELECT   ''__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+'' AS "*"
                   FOR XML PATH('''')
               )
             , '',''
             , ''</RowData><RowData>''
                      ) + ''</RowData></XMLRoot>'' AS XML) AS "x";

SELECT  ''__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+'' AS "*"
FOR XML PATH(''RowData'')';
EXEC sp_describe_first_result_set @query, NULL, 0;
GO

DECLARE @query NVARCHAR(MAX) = N'SELECT CAST(''<XMLRoot><RowData>'' + REPLACE((SELECT  ''__RequestVerificationToken=Mm8qFNjv6BfLKoZQazX9sCjQhP6AjiCh09kdeeufFHP8l2DnGUF1fUq0ytIjg0wXcIFrCbSU7wPQ57XZbDXOW4VFSVLmZq7GpAlALdSazWgte339GO4w5bzd9Q-R2v8SVPhC4sqsVV7G-f34Uo3D7A2&__RequestVerificationToken=XBntsuM8eJ1hUOHDpM9LZjHCB8u1qxg_OFNgKs5g7XL9vSImR4FNc1ZUM5HLPG2DdhDUG40mm_-kgousIdJmrySu-Z7iIzslDlKkBhJAB9Y1&PolicyCoreInformation.PolicyTermID=3779392&PolicyCoreInformation.PolicyTermSnapshotID=8702256&PolicyCoreInformation.PolicyWrittenPremium=0.0000&PolicyCoreInformation.PolicyPropertyState=FL&PolicyCoreInformation.CustomerEmailAddress=russellcharles281%40gmail.com&PolicyCoreInformation.PolicyNumber=82328659&PolicyCoreInformation.PolicyNumberAndTerm=82328659++%5b0%5d&PolicyCoreInformation.ProductType=PrivateFloodHomeowners&PolicyCoreInformation.AgencyPartyID=383&PolicyCoreInformation_AgencyPartyID_Display=Foundation+Insurance+of+Florida&PolicyCoreInformation.EffectiveDate=4%2f13%2f2022+12%3a01%3a00+AM&PolicyCoreInformation.UWCompanyName=Trisura+Specialty+Insurance+'' AS [*] FOR XML PATH('''')),'','',''</RowData><RowData>'') + ''</RowData></XMLRoot>'' AS XML) AS x';
EXEC sp_describe_first_result_set @query, NULL, 0;
GO


SELECT system_type_id, name
FROM sys.types
WHERE system_type_id = user_type_id

