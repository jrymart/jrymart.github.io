---
layout: post
title: "Small Projects over Tiny"
date: 2024-03-27
---
A few months ago some friends of mine put together the silly and fun [One Knight Stand](https://oneknightstand.club).
It's a fun little chess game I encourage you to check out; the gist is that you make one and only one move on a game before it is whisked away for someone else to make the next move, and so on and so on.
My coding experience consits of a handful of CS classes and the type of code you write when you're the only person in your lab group who writes code, so suffice to say I did not feel able to take part in the fast paced development of a web app.
Fast forward to today: One Knight Stand has been working for a few months, and my friends are dutifully plugging away, periodically making improvements.
I noticed a small, me-sized bug: your ELO score does not correctly display when you first log in; instead it updates after you make your first move of the session (later I realized it updates 20 seconds after a new session).
I'm on spring break, so I decided to try to fix it.
The One Knight Stand codebase is, as far as code bases go, quite small, I'd say just a tad bigger than a tiny tutorial.
It uses Django and Python for the back-end, and Svelte and TypeScript for the front end.
I know Python, but I haven't touched JavaScript for about 7 years, let alone something like Svelte.
It took me about two hours to fix, and I learned a tiny bit about Django and a small amount about Svelete, aynchronous programming, web development, and GitHub.

I don't think I would have learned as much so quickly going through a tutorial.
In the past, library tutorials leave me feeling bored.
If I don't have a pressing need to learn whatever tool it is, I give up, and if I do, have a need, I rush ahead until I do it badly enough I start to learn something.
Diving in to a well designed project that was small enough to for me to grok, and with a really simple doable goal was the most fun I've had learning something new in a while.
I think most importantly, it let me learn in the way that felt the most natural for me, instead of putting me on rails to build up the necessary set of skills to do something more interesting from scratch.
I wonder if this could be incorporated into getting started guides for new tools: rather than holding your hand all the way through something tiny, you get thrown in and have to solve a problem on something small.

Back when I was a security engineer, this is actually how I learned things.
My company would pay vendors hundreds of dollars to put me through the most mind numbing courses on their tech, but I only really learned things when I had a task to do with it.
And those tasks were never "set this up from scratch", they were almost always fixing something small.
I wonder if there are lessons here I can take to the classes I teach...
