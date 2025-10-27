; aiengineer.ahk
; AutoHotkey (v1) script to expand the trigger "/aiengineer" into a greeting.
; Save this file and double-click it to run with AutoHotkey on Windows.

; When you type: /aiengineer followed by a terminating character (space, Enter, punctuation)
; it will be replaced with the greeting below.

::/aiengineer::
SendRaw, Thank you for your interest. I am linking my CV, which details my experience as an AI Engineer in building and deploying secure, scalable Generative AI and LLM-based applications.

A summary of my core AI competencies and key project accomplishments is included below for your review.

📄 CV: https://docs.google.com/document/d/1mEwGZ6GG9sPfphk0-0t6tq0MxgSVuoVS/edit?usp=sharing&ouid=118307655303235244249&rtpof=true&sd=true
I am available to discuss my work on RAG architectures, AI-driven CI/CD, and secure model deployment. Please feel free to reach me directly at 📞 +447848024173 or schedule a time via Calendly.

📅 Schedule: https://calendly.com/rifaterdem/schedule

Best regards, Rifat Erdem Sahin
Return

; --- Notes ---
; - This is a simple hotstring replacement using AutoHotkey v1 hotstrings.
; - If you want case-insensitive matching, change the hotstring to:
;   :i:/aiengineer::
; - If you want to include an ending space automatically, you can append a space
;   in the SendRaw line like: SendRaw, hello ... engineer. 
;   But AutoHotkey will normally send the typed ending character for you.
