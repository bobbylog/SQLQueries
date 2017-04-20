SELECT TC.TextTerm, SR.*, TC.Term

FROM SRAcademic SR
LEFT OUTER JOIN TermCalendar TC
      ON (SR.TermCalendarID = TC.TermCalendarID)
WHERE (TermGPAHours = 0 OR CumulativeGPAHours = 0) AND Credits > 0
ORDER BY TC.Term, StudentUID