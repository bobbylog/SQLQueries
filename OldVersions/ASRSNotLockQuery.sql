SELECT dbo.FinancialISAR.StudentFirst, dbo.FinancialISAR.StudentLast, dbo.FinancialISAR.StudentMiddle, dbo.FinancialISAR.ActiveFlag, dbo.FinancialISAR.Lock, 
               dbo.FinancialISAR.InsertUserID, dbo.FinancialISAR.InsertTime, dbo.FinancialISAR.ApplicationRecvDT, dbo.Student.StudentSSN, dbo.TermCalendar.Term, 
               dbo.TermCalendar.TextTerm
FROM  dbo.FinancialISAR INNER JOIN
               dbo.Student ON dbo.FinancialISAR.StudentSSN = dbo.Student.StudentSSN INNER JOIN
               dbo.StudentStatus ON dbo.Student.StudentUID = dbo.StudentStatus.StudentUID INNER JOIN
               dbo.TermCalendar ON dbo.StudentStatus.TermCalendarID = dbo.TermCalendar.TermCalendarID
WHERE (dbo.FinancialISAR.ActiveFlag = 1) AND (dbo.FinancialISAR.Lock = 0) AND (dbo.TermCalendar.TextTerm IN ('FA-15', 'SP-15', 'SU-15', 'SU-BSN-15', 'FA-BSN-15', 
               'SP-16'))