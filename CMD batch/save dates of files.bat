@ ECHO OFF 
(FOR /f "delims=" %%a IN ('dir /b /a-d') DO (
    FOR /f "tokens=1-3*" %%x IN ('dir /a-d /tc "%%~a"^|findstr "^[0-9]"') DO (
        ECHO "%%a"		%%~ta,%%x %%y %%z
    )
)) > DIR.txt

TYPE DIR.txt