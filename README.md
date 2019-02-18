# CS-Switch-Soundtrack-Extractor
A few scripts that when used correctly can extract Switch exclusive soundtracks

FIRST AND FOREMOST!
For any of this script to work, you MUST have a populated keys.txt
I have set up a template with the correct lengths of the keys you need in keys.txt, and given
the first 4 chars so you know what to look for.
Your Switch keys can be dumped by running Schmue's fork of kezplez-nx: https://github.com/shchmue/kezplez-nx/releases
or
(While I do not condone it) You can find the necessary keys online when searching in the right places.

========================================================================================================================

Other important thing to note, this script requires you to have python installed.
I'm unsure if it works on 2.7.X, but I used python 3.7.0 when making this, so I recommend that version.
Make sure to have that so it can run properly.

========================================================================================================================

You also need to have dumped or "acquired" a US CS+ cartdridge dump (XCI), or a US/EUR CS+ Update/Game digital dump (NSP)
to work with.

========================================================================================================================

For the NSPs you will need the respective 32-char titlekey for the title (these can also be found online),
each region and form of nsp have one.
E.g.
	EUR Base-Game has titlekey -> WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
	EUR Update has titlekey -> XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	US Base-Game has titlekey -> YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY
	US Update has titlekey -> ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
Putting it simply, each NSP has a different 32-char titlekey, and the correct titlekey must be used with the correct NSP.

========================================================================================================================

USAGE:

For Famitracks/ogg17:
Place your base game XCI/NSP into CS-Base\, and then run the batch script and follow the prompts.

For Ridiculon/ridic
Place your update NSP into CS-Update\, and then run the batch script and follow the prompts.

========================================================================================================================

If you have any questions feel free to ping me in the NetXEngine Discord, and if/when I'm not busy I'll
try to help.
