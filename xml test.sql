DECLARE @xmlTest XML = N'<Test><TagName>1</TagName><TagName>2</TagName></Test>';

DECLARE @ustrConvertedXML NVARCHAR(MAX) = CONVERT(NVARCHAR(MAX), @xmlTest);

SELECT  DATALENGTH(@xmlTest) AS [XmlBytes]
      , LEN(@ustrConvertedXML) AS [StringCharacters]
      , DATALENGTH(@ustrConvertedXML) AS [StringBytes];

SET @xmlTest = N'<Test><TagName>1</TagName><TagName>2</TagName><TagName>3</TagName>
<TagName>4</TagName><TagName>5</TagName><TagName>6</TagName></Test>';

SET @ustrConvertedXML = CONVERT(NVARCHAR(MAX), @xmlTest);

SELECT  DATALENGTH(@xmlTest) AS [XmlBytes]
      , LEN(@ustrConvertedXML) AS [StringCharacters]
      , DATALENGTH(@ustrConvertedXML) AS [StringBytes];



