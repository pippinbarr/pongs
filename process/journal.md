# Design Journal

This "design journal" is made up of posts I wrote on my public-facing blog while making *PONGS*.

## New Project Status (2012-04-03)

The new game I&#8217;ve been making is so far called _PONGS_ and it&#8217;s&#8230; a whole lot of_ PONG_s. So to speak. On the plane-ride home from Greece a while back I amused myself by trying to come up with ten different versions of _PONG_. Mostly I thought of it as trying to think of a whole lot of &#8220;gags&#8221; based on the mechanics and appearance of the original _PONG_ (though I think it&#8217;s evolved in a little more than that now). When I got to ten I wasn&#8217;t back in Copenhagen yet, so I kept going. Eventually I made it to 25, which I was pretty pleased with. Now, after culling a couple and adding a couple, I have 26. The whole thing has been an interesting experiment in trying to work in terms of variations instead of one monolithic idea, it&#8217;s been quite a pleasing challenging. I have a few more things to do yet, but figure _PONGS_ will be all done in a week or so.

## From Uh-Oh to OO (2012-04-05)

So I&#8217;ve been toiling away at _PONGS_. I made 26 variations on _PONG_ and then thought I was finished with it and would polish and release by next week. But then I was talking to Rilla and we thought of a couple more variants that simply _had_ to be part of the collection. And once there were two more there really needed to be ten more. You know, for the children. But this led to a bit of an issue, because the way I coded the first 26 was a massive pain in the ass&#8230;

<!--more-->

You see, I watched this [pretty cool talk by Jonathan Blow](http://the-witness.net/news/2011/06/how-to-program-independent-games/) where he talks about how you really shouldn&#8217;t bother with making your code &#8220;nice&#8221; as you go. Instead of thinking up clever data structures and efficient algorithms you should just do what works there and then so you can keep surging forwards. He makes a pretty nice case for the whole thing and I certainly found myself more or less convinced by the time all was said and done.

The problem is I think I got a little too into the message of &#8220;surge ahead&#8221;, so I adopting a particularly crappy way of writing my PONG variants. In particular, I wrote a &#8220;standard&#8221; version of PONG, and then I cut and paste _all_ the code into a new file and then hacked it into each variant. That is, each file bears no relationship whatsoever to any other. Want to change the fonts used? Change all 26 files. Want to change how fast the ball moves? Change all 26 files. And so on.

And of course programming has, for a rather long time, had a specific solution to _exactly this ridiculous situation_. It&#8217;s called inheritance, and it&#8217;s pretty goddamn fundamental to object oriented programming. I didn&#8217;t use it because I was momentarily blinded my what I can only assume is my misinterpretation of Blow&#8217;s talk. Of _course_ you should make 26 variants on PONG by using inheritance from a standard PONG. Good god man!

And so today I went back through it all and did just that, streamlining all the code so it inherits from the standard PONG code and just makes the changes necessary. Files that were a few hundred lines long shrunk to 10% or less of their size. The code actually _made sense to read_. I could now change fonts whenever I damned well pleased. It was pretty magical. I&#8217;m actually _glad_ I didn&#8217;t used inheritance in the beginning just so I could _see explicitly_ how wonderful it is to use inheritance by changing over. Not to mention how nice it has been starting work on the &#8220;final&#8221; 10 variants this evening and adding them to the inheritance structure. My my.

In short, it&#8217;s totally cool to forge ahead and code &#8220;what works&#8221;, but that probably shouldn&#8217;t include absolutely fundamental programming concepts. Just a heads up.

## This Is What It Sounds Like When Sprites Don&#8217;t Collide (2012-04-06)

Today I found myself lying on the couch feeling maudlin about sprite collision detection and resolution. It was not unlike speaking to my silent (and admittedly non-existent) therapist when I gave a small speech about how I wished I was smarter and knew how to things like collision. I fervently wished at that moment I was a mathematician or physicist or, damnit, just a better programmer! But no, I&#8217;m none of these things and so have been battling away with some collision stuff for _PONGS_ for a good chunk of today.

<!--more-->

I&#8217;m using Photonstorm&#8217;s awesome pixel perfect collision checking to find out if the ball is hitting certain falling shapes in a particular level of _PONGS_. That all works like a dream, but the problem is that the Photonstorm code doesn&#8217;t actually help you to _resolve_ the collision. That is, you know that things hit each other, but not what to do about it in response. I&#8217;ve spent time looking at how Flixel resolves collisions between simple bounding boxes, but even that kind of zooms over my head. I get bits of it, then maybe some other bits, but by then the original bits are all gone again. Hopeless.

I solved one problem just before starting to write this, but the larger problem of the ball itself is proving super problematic. Sometimes it behaves itself. But sometimes it passes through solid objects, or bounces off them at entirely the wrong handle. And just when I&#8217;ve plugged one problem up, another springs loose. Most annoyingly, because _PONGS_ is so simple, I don&#8217;t think I can afford to include any minigame in it that isn&#8217;t mostly &#8220;perfect&#8221; in its behaviour, so I need to get this right or abandon the idea. Gah.

So anyway, wish I was a physics whiz is all.

## The Ecstasy and the Apathy (2012-04-09)

I pretty much wound up my work on _PONGS_ today. There are 36 variations on classic _PONG_ in there, out of I suppose around almost 50 that I thought of and often even implemented before throwing away. The game started with me challenging myself to come up with multiple versions of _PONG_ while flying from Athens to Copenhagen and I was super excited about it right from the beginning. Now it&#8217;s done, I feel kind of sad.

<!--more-->

To some extent it&#8217;s par for the course. Whenever you finish a project there can be that weird lull and depression. After all, you don&#8217;t have that project to work on any more. With _PONGS_ though it seems particularly disappointing. Basically, _PONGS_ was just so much fun to make. The combination of a really simple base level with the chance to just come up with super random ideas for how to alter it was great. Making snack size games turns out to be pretty wonderful, in short. Now that the snacks are finished, I feel I&#8217;m having a bit of a sugar crash.

Definitely suggests to me that working on another minigame collection some time in the near future would be a good idea. Look for _PONGS_ in the next couple of days!

## PONGSed (2012-04-11)

So I released _[PONGS](http://www.pippinbarr.com/games/pongs/Pongs.html)_ today, just two weeks after [_Epic Sax Game_](www.pippinbarr.com/games/epicsaxgame/EpicSaxGame.html). There was some talk of delaying putting it out for a bit longer, to give myself (and possibly the Internet itself!) a break from my games production line, but in the end&#8230; no, it was a bit too exciting and I didn&#8217;t want to just hold onto it. In fact, _PONGS_ is something I&#8217;m genuinely proud of.

<!--more-->

Not that I&#8217;m not proud of the other games, but _PONGS_ has been close to my heart. Perhaps because it&#8217;s been such a Spring Fling of a game, over in two weeks, hot and tawdry while it lasted&#8230; or something. Perhaps not that. But at the very least it was the most fun I&#8217;ve had making a game from start to finish in a fair while. It&#8217;s certainly another one of those nice &#8220;this game needs to exist&#8221; games, which is always a pleasure to put together and insert into reality &#8211; frankly it seems important that such games are made. Perhaps they fill some kind of gap in the space-time continuum. Or perhaps I just find them really funny.

As per usual, I think about _PONGS_ in a couple of ways. First of all, a lot the ideas in there make me chuckle to think about and to experience when I play them. There&#8217;s plenty of good-natured ribbing of game design trends (serious games, edutainment) and tributes to existing games (_Shit Snake_, _B.U.T.T.O.N._, and more classic games like _Tetris_), and plenty of the games just &#8220;feel funny&#8221; to play for other reasons: perhaps the mechanics or the controls themselves are comical? Your mileage may vary, you stony-faced son of a gun!

Second, I&#8217;m really pleased to claim that (at least for myself and a couple of testers) a number of the variants are actually fun to play! This is kind of virgin territory for me in a lot of ways &#8211; it&#8217;s never been my objective to make games that are enjoyable in the traditional sense, so it&#8217;s with great interest that I found myself enjoying some of _PONGS_. LASER PONG and MEMORIES OF PONG are examples of this strange new phenomenon. Once again, your mileage may vary.

Finally, as with all these projects, _PONGS_ has come to symbolise certain &#8220;larger&#8221; issues of game design for me. In particular, making variants of something as simple as _PONG_ helped me to distill in some way what games might be made of. Or rather than that, perhaps, it has been in _playing_ the games and seeing how much of a difference a tiny rule change makes to the experience (and strategies and all that) of play that have been illustrative. I&#8217;m not clear that it&#8217;s helped me perceive any deeper truths about &#8220;what games are&#8221; or anything, but experientially, at least, it has _felt_ interesting and worthwhile. You mileage will almost certainly vary.

And, after all, isn&#8217;t it all about variable mileage in the end?
