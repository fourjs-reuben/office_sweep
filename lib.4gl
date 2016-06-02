IMPORT util
IMPORT xml

FUNCTION get_now_utc()
DEFINE now DATETIME YEAR TO MINUTE

   LET now = CURRENT YEAR TO MINUTE
   LET now = util.Datetime.toUTC(now)
   RETURN now
END FUNCTION



FUNCTION rows_updated()
   RETURN SQLCA.SQLERRD[3]
END FUNCTION



FUNCTION is_blank(s)
DEFINE s STRING

   IF s IS NULL THEN
      RETURN TRUE
   END IF
   LET s = s.trim()
   IF s.getLength()=0 THEN
      RETURN TRUE
   END IF
   RETURN FALSE
END FUNCTION



FUNCTION encrypt_password(p)
DEFINE p,e STRING
DEFINE key xml.CryptoKey
DEFINE secret STRING

    LET secret = "1234567890123456" --128 bits
    LET key = xml.CryptoKey.Create("http://www.w3.org/2001/04/xmlenc#aes128-cbc")
    CALL key.setKey(secret)
    LET e =  xml.Encryption.EncryptString(key,p)
    RETURN e
END FUNCTION

FUNCTION decrypt_password(e)
DEFINE p,e STRING
DEFINE key xml.CryptoKey
DEFINE secret STRING

    LET secret = "1234567890123456" --128 bits
    LET key = xml.CryptoKey.Create("http://www.w3.org/2001/04/xmlenc#aes128-cbc")
    CALL key.setKey(secret)
    LET p =  xml.Encryption.DecryptString(key,e)
    RETURN p
END FUNCTION
