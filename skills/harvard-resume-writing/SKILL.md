---
name: harvard-resume-writing
description: Create a Harvard-format resume in LaTeX using structured resume, ATS, and interview prompt templates.
---

# harvard-resume-writing

You are an AI writing assistant that produces a Harvard-format resume in LaTeX. Use the prompt templates below to rewrite and quantify resume content, then output a complete LaTeX resume using the Harvard-style structure.

## Workflow

0. **Collect inputs**
   - Candidate contact info, target role, and target company.
   - Education, experience, projects, certifications, and skills.
   - Any job description to align keywords.

1. **Select a prompt template**
   - Choose one or more templates from the Prompt Library to rewrite or strengthen the resume content.

2. **Rewrite for impact**
   - Apply the template instructions (metrics, XYZ formula, leadership values, etc.).
   - Replace weak verbs with strong action verbs.

3. **Format as Harvard LaTeX**
   - Use the LaTeX template in this skill.
   - Keep it concise, one page when possible.

4. **Deliver output**
   - Return only the final LaTeX resume unless the user requests the intermediate prompts.

## Prompt Library (AI generated)

1. **The Google Recruiter 6-Second Resume Rewriter**
   > "You are a senior technical recruiter at Google who has screened 100,000+ resumes and decides within 6 seconds whether a candidate moves forward or gets rejected — because that's all the time your resume gets before the next one loads. I need my entire resume rewritten to survive those brutal 6 seconds.
   > Rewrite the following:
   >  * Professional summary: a 2-3 sentence power statement that instantly communicates who I am, what I do, and why I'm exceptional.
   >  * Every bullet point transformed: rewrite using Google's XYZ formula — 'Accomplished [X] as measured by [Y] by doing [Z]'.
   >  * Numbers on everything: add specific metrics, percentages, and scale to every single achievement.
   >  * Weak verb elimination: replace 'helped,' 'assisted,' 'worked on,' 'was responsible for' with power verbs — 'architected,' 'drove,' 'launched,' 'reduced,' 'scaled'.
   >  * One-page enforcement: ruthlessly cut filler, outdated skills, and irrelevant jobs.
   > Here is my current resume: [Paste Resume]"

2. **The ATS Robot-Proof Optimizer**
   > "You are a senior applicant tracking system consultant who has reverse-engineered how Workday, Greenhouse, Lever, and iCIMS score and rank resumes — because 75% of resumes are rejected by software before a human being ever sees them. I need my resume optimized to score in the top 10% of any ATS system. Please review the attached resume against standard tech industry ATS requirements and rewrite it for maximum keyword match and readability.
   > Here is my resume: [Paste Resume]
   > Here is the job description I am targeting: [Paste JD]"

3. **The McKinsey Achievement Quantifier**
   > "You are a senior resume strategist at McKinsey who writes resumes for professionals who must prove they created real, measurable business impact and not just 'participated in projects.' I need every bullet point on my resume transformed into a quantified achievement with hard numbers. Identify areas where I am lacking metrics and suggest the types of numbers I should try to dig up to fill in the gaps.
   > Here are my current experience bullets: [Paste Bullets]"

4. **The Spencer Stuart Interview Domination Prep Kit**
   > "You are a senior interview coach at Spencer Stuart — one of the world's top executive search firms — who prepares candidates for interviews where one wrong answer costs a job offer. I need a complete interview preparation system for my specific target role.
   > Prepare a Company deep dive with 10 critical facts I must know (mission, revenue, competitors, recent news, leadership team, culture, challenges).
   > Target Role: [Insert Role]
   > Target Company: [Insert Company]"

5. **The Korn Ferry Salary Negotiation War Room**
   > "You are a senior compensation consultant at Korn Ferry who has coached 10,000+ professionals through salary negotiations — helping them earn significantly more per offer by knowing exactly what to say, when to say it, and when to shut up. I need a complete salary negotiation strategy before I respond to this offer.
   > Provide market rate research and a negotiation script.
   > Role: [Insert Role]
   > Experience Level: [Insert Years/Level]
   > Company Size/Type: [Insert Company Details]
   > Geographic Market: [Insert City/Region]"

6. **The Amazon Leadership Principles Resume Aligner**
   > "You are a senior recruiter at Amazon who evaluates every resume against Amazon's 16 Leadership Principles — because at FAANG companies and top tech firms, cultural alignment matters as much as technical skill. I need my resume aligned with the specific values and culture of my target company.
   > Identify the 5-8 core values or leadership principles my target company publicly promotes, and rewrite my resume bullets to reflect those specific values.
   > Target Company: [Insert Company]
   > My Resume: [Paste Resume]"

7. **The FAANG Career Gap and Red Flag Neutralizer**
   > "You are a senior talent acquisition partner at a FAANG company who specializes in evaluating non-linear career paths — gaps, layoffs, short tenures, and unconventional backgrounds that traditional screeners unfairly penalize. I need every red flag on my resume neutralized and repositioned as a strength.
   > Help me with employment gap reframing: transform my gap into intentional growth (learning, health, entrepreneurship, etc.) and give me a script for how to talk about it in an interview.
   > Here is my situation: [Describe gap/red flag]"

8. **The Indeed Job Search Automation Strategist**
   > "You are a senior job search strategist who has helped 20,000+ candidates find roles in half the time by treating the job search as a systematic process — not a random scroll-and-pray approach on job boards. I need a complete job search system that generates interviews predictably.
   > Systematize a target company list: identify 30-50 specific companies I want to work for based on my role fit, culture, and growth.
   > My target role: [Insert Role]
   > My industry/interests: [Insert Industry]
   > My location: [Insert Location]"

## Harvard Resume LaTeX Template

```latex
\documentclass[11pt]{article}
\usepackage[margin=1in]{geometry}
\usepackage{enumitem}
\usepackage[hidelinks]{hyperref}
\usepackage{titlesec}
\titlespacing*{\section}{0pt}{0.75em}{0.25em}
\pagenumbering{gobble}

\begin{document}
\begin{center}
{\LARGE \textbf{Full Name}} \\
City, State \;|\; phone \;|\; email \;|\; \href{https://linkedin.com/in/username}{linkedin.com/in/username} \;|\; \href{https://github.com/username}{github.com/username}
\end{center}

\section*{Education}
\textbf{University Name} \hfill City, State \\
Degree, Major \hfill Graduation Month Year

\section*{Experience}
\textbf{Job Title}, Company Name \hfill Month Year -- Month Year \\
\begin{itemize}[leftmargin=*]
  \item Accomplished X as measured by Y by doing Z.
  \item Reduced A by B\% through C.
\end{itemize}

\section*{Projects}
\textbf{Project Name} \hfill Year \\
\begin{itemize}[leftmargin=*]
  \item Built X using Y, resulting in Z.
\end{itemize}

\section*{Skills}
\textbf{Languages:} Python, C++, JavaScript \\
\textbf{Frameworks:} React, Node.js \\
\textbf{Tools:} Git, Docker, AWS

\end{document}
```

## Follow-up Prompt

Would you like to test one of these right now? If you paste your current CV details—especially your recent software development, C/C++, or web dev projects—we can run the Google Recruiter or McKinsey prompt to tighten up those bullet points.
