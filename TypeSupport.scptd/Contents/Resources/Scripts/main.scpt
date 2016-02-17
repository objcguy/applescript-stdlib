FasdUAS 1.101.10   ��   ��    k             l      ��  ��    � � TypeSupport -- various standardized handlers for coercing and checking parameters and throwing errors

Notes:

- Because AS errors don't include stack traces, a library's public handlers must trap and rethrow all errors, prefixing error string with library and handler name (and, in script object methods, the object's display/documentation name) so that user can identify the handler in which an error occurred. Special attention should also be paid to coercing and/or validating public handlers' parameters, and throwing descriptive errors if an inappropriate value is given.

- This library wouldn't be necessary if AppleScript had decent parameter type annotations and proper exception objects (with full stack trace support). But as it doesn't these handlers at least take some of the endless pain out of sanitizing user-supplied inputs and generating consistent error messages when those inputs are inappropriate, or anything else in the handler needs to throw an error (or just goes plain old wrong).

- When coercing a text value to integer/real/number, or an integer or real value to text, the text is parsed/formatted using the current user's localization settings.

- When coercing a list to text, AppleScript's current text item delimiters are used. (This may change in future.)

- Library handlers that work with the file system should use asPOSIXPathParameter(...) to check and normalize user-supplied alias/file/�class furl�/POSIX path string parameters as POSIX path strings. (If a file object is specifically required, just coerce the returned POSIX path to `POSIX file`.) This should insulate library handlers from the worst of the mess that is AS's file identifier types.


Caution:

- When checking if a string is empty in a library handler, it is *essential* either to check its length=0 or else wrap the string comparison (e.g. `aString is ""`) in a `considering hyphens, punctuation and white space block` to ensure that it really is empty and not a non-empty text value that contains only characters being ignored by the caller's current considering/ignoring settings. Similarly, when comparing for a non-empty string, the considering block *must* be used.

- When performing comparisons using <,�,>,� operators or concatenating values with & operator, it is *essential* to ensure the left operand is of the correct type (number/text/date/list) as AS will coerce the RH operand to the same type as the LH operand, and in some cases even casts *both* (e.g. `1&2`->`{1}&{2}`->`{1,2}`). Conversely, when using =/� operators, if the two operands are not the same type then this will almost always result in `false` (the obvious exception being integer/real comparisons, e.g. `1=1.0`->true), even though type-only differences are often ignored by other operators/commands (e.g. `1<"1"->false, `1<{1}`->false). Fully sanitizing all handler parameters before using them should generally avoid such problems subsequently manifesting in the handler, but eternal vigilance is still required to ensure extremely obscure/nasty/unpredictable/almost-impossible-to-troubleshoot bugs don't sneak in.

TO DO:

- eliminate SDEF terminology for `native type`, `check type`, and `convert to Cocoa` commands and use identifier-based names instead? This would be consistent with rest of library's handlers, and avoid the obvious gotcha where user forgets to include parameter name in command and passes value as direct parameter instead command (which is disallowed here since the value can be anything, including script objects which aren't suitable as direct parameters to keyword-based commands due to AS's eccentric dispatch rules). Alternatively, could define `convert to TYPE` terminology for all `asTYPEParameter` commands, which is handy for optional params (e.g. parameter name could be optional; if omitted, generates different error message). e.g. `convert to text from theValue for parameter "using"`


- in `check type`, how to provide option for checking if value is a *list* of the specified type? one option would be to provide both `is` and `is list of` parameters on `check type`; another would be to provide a separate `check item type for LIST is TYPE` command. 

	(Note that checking if value is a record of specific form, e.g. `{name:text, isDone:boolean}`, is impractical due to the lack of AS introspection and the inability of ASOC's record-to-NSDictionary conversion to preserve keyword based names, therefore it's not worth trying to implement that.)
	
	(Be aware that while the `count` command's `each` parameter claims to accept a list of type classes, this is no good for actually determining if all list items are one of those types. It looks like when a list is given it actually counts all the values that can be _coerced_ one of specified types (as per `as` operator enhancement in 10.10), not whether the value is actually one of those types. Thus when checking a list for multiple types, it's necessary to check each item against each type O(nm), as it's possible for two type names to match the same item (e.g. counting each `integer`, then each `real`, then each `text` and summing the result should be ok, but counting each `integer`, then each `number`, then each `real` would result in all integer and real items being counted twice), resulting in an incorrect count when the subtotals for each time are finally added up. While AS's collection type names is quite stable, making it tempting to hack in special-case checks to prevent such overcounts, it's impossible to guarantee new names won't be added in future, so that isn't a safe solution.)


- add `check coercion` handler that checks if value can [safely?] be coerced to the specified type (Q. does `count {theValue} each {theType}` work same as `theValue as {theType}` by first testing for exact type then testing for coercibility?)

- add `check AppleScriptObjC class` handler that checks if value is ocid specifier and its class name is specified string?


- note: make sure `asTYPEParameter` handlers will always accept ASOC objects, coercing to corresponding AS type (i.e. don't add any checks that'd cause them to reject 'ocid' specifiers), e.g. `asNumberParameter` will probably currently fail on ASOC object as it doesn't first coerce to `any`; might be best if all `asTYPEParameter` handlers first coerce to `any` before coercing to actual required type (the only exception would be an `asReferenceParameter` handler, as that needs to typecheck only, as coercing a reference dereferences it)

- should asTextParameter() always throw an error if value is a list? (i.e. avoids inconsistent concatenation results due to TIDs); another option would be to whitelist some or all known 'safe' types (integer/real, text, date, alias/file/furl, etc) and reject everything else; this should ensure stable predictable behavior - even where additional custom coercion handlers are installed (users can still use other types of values, of course; they just have to explicitly coerce them first using `as` operator)

 - also, `missing value` and other type/constant symbols are currently accepted by asTextParameter (though may coerce to either keyword name text or raw chevron text, which may be a reason for `asTextParameter` to disallow them; see also handling of month and weekday constants in `asInteger/Real/NumberParameter`) so will not trigger -1703; script objects, app refs, etc. will trigger -1708 due to direct parameter dispatch (i.e. `uppercase text` gets dispatched to them instead of Text) 



- should `as[Integer/Real/Number]Parameter` handlers explicitly check for and reject non-number-like values that AS would normally coerce to numbers? Probably, e.g. just because January..December and Monday..Sunday constants _can_ coerce doesn't mean they should, as if they're being passed to a handler that expects a regular number then it almost certainly indicates a mistake in the user's code that should be drawn to her attention. For example, using Standard Additions:

	random number from January to December --> 0.0-1.0 (wrong! this is a bug in `random number` osax handler where it silently ignores non-numeric parameter types instead of reporting coercion error)	random number from (January as integer) to (December as integer) --> 1-12
	
	(Caveat: see above about not rejecting ASOC objects. Will need to be careful to allow NSNumber/NSString, though not NSAppleEventDescriptor)

     � 	 	A�   T y p e S u p p o r t   - -   v a r i o u s   s t a n d a r d i z e d   h a n d l e r s   f o r   c o e r c i n g   a n d   c h e c k i n g   p a r a m e t e r s   a n d   t h r o w i n g   e r r o r s 
 
 N o t e s : 
 
 -   B e c a u s e   A S   e r r o r s   d o n ' t   i n c l u d e   s t a c k   t r a c e s ,   a   l i b r a r y ' s   p u b l i c   h a n d l e r s   m u s t   t r a p   a n d   r e t h r o w   a l l   e r r o r s ,   p r e f i x i n g   e r r o r   s t r i n g   w i t h   l i b r a r y   a n d   h a n d l e r   n a m e   ( a n d ,   i n   s c r i p t   o b j e c t   m e t h o d s ,   t h e   o b j e c t ' s   d i s p l a y / d o c u m e n t a t i o n   n a m e )   s o   t h a t   u s e r   c a n   i d e n t i f y   t h e   h a n d l e r   i n   w h i c h   a n   e r r o r   o c c u r r e d .   S p e c i a l   a t t e n t i o n   s h o u l d   a l s o   b e   p a i d   t o   c o e r c i n g   a n d / o r   v a l i d a t i n g   p u b l i c   h a n d l e r s '   p a r a m e t e r s ,   a n d   t h r o w i n g   d e s c r i p t i v e   e r r o r s   i f   a n   i n a p p r o p r i a t e   v a l u e   i s   g i v e n . 
 
 -   T h i s   l i b r a r y   w o u l d n ' t   b e   n e c e s s a r y   i f   A p p l e S c r i p t   h a d   d e c e n t   p a r a m e t e r   t y p e   a n n o t a t i o n s   a n d   p r o p e r   e x c e p t i o n   o b j e c t s   ( w i t h   f u l l   s t a c k   t r a c e   s u p p o r t ) .   B u t   a s   i t   d o e s n ' t   t h e s e   h a n d l e r s   a t   l e a s t   t a k e   s o m e   o f   t h e   e n d l e s s   p a i n   o u t   o f   s a n i t i z i n g   u s e r - s u p p l i e d   i n p u t s   a n d   g e n e r a t i n g   c o n s i s t e n t   e r r o r   m e s s a g e s   w h e n   t h o s e   i n p u t s   a r e   i n a p p r o p r i a t e ,   o r   a n y t h i n g   e l s e   i n   t h e   h a n d l e r   n e e d s   t o   t h r o w   a n   e r r o r   ( o r   j u s t   g o e s   p l a i n   o l d   w r o n g ) . 
 
 -   W h e n   c o e r c i n g   a   t e x t   v a l u e   t o   i n t e g e r / r e a l / n u m b e r ,   o r   a n   i n t e g e r   o r   r e a l   v a l u e   t o   t e x t ,   t h e   t e x t   i s   p a r s e d / f o r m a t t e d   u s i n g   t h e   c u r r e n t   u s e r ' s   l o c a l i z a t i o n   s e t t i n g s . 
 
 -   W h e n   c o e r c i n g   a   l i s t   t o   t e x t ,   A p p l e S c r i p t ' s   c u r r e n t   t e x t   i t e m   d e l i m i t e r s   a r e   u s e d .   ( T h i s   m a y   c h a n g e   i n   f u t u r e . ) 
 
 -   L i b r a r y   h a n d l e r s   t h a t   w o r k   w i t h   t h e   f i l e   s y s t e m   s h o u l d   u s e   a s P O S I X P a t h P a r a m e t e r ( . . . )   t o   c h e c k   a n d   n o r m a l i z e   u s e r - s u p p l i e d   a l i a s / f i l e / � c l a s s   f u r l � / P O S I X   p a t h   s t r i n g   p a r a m e t e r s   a s   P O S I X   p a t h   s t r i n g s .   ( I f   a   f i l e   o b j e c t   i s   s p e c i f i c a l l y   r e q u i r e d ,   j u s t   c o e r c e   t h e   r e t u r n e d   P O S I X   p a t h   t o   ` P O S I X   f i l e ` . )   T h i s   s h o u l d   i n s u l a t e   l i b r a r y   h a n d l e r s   f r o m   t h e   w o r s t   o f   t h e   m e s s   t h a t   i s   A S ' s   f i l e   i d e n t i f i e r   t y p e s . 
 
 
 C a u t i o n : 
 
 -   W h e n   c h e c k i n g   i f   a   s t r i n g   i s   e m p t y   i n   a   l i b r a r y   h a n d l e r ,   i t   i s   * e s s e n t i a l *   e i t h e r   t o   c h e c k   i t s   l e n g t h = 0   o r   e l s e   w r a p   t h e   s t r i n g   c o m p a r i s o n   ( e . g .   ` a S t r i n g   i s   " " ` )   i n   a   ` c o n s i d e r i n g   h y p h e n s ,   p u n c t u a t i o n   a n d   w h i t e   s p a c e   b l o c k `   t o   e n s u r e   t h a t   i t   r e a l l y   i s   e m p t y   a n d   n o t   a   n o n - e m p t y   t e x t   v a l u e   t h a t   c o n t a i n s   o n l y   c h a r a c t e r s   b e i n g   i g n o r e d   b y   t h e   c a l l e r ' s   c u r r e n t   c o n s i d e r i n g / i g n o r i n g   s e t t i n g s .   S i m i l a r l y ,   w h e n   c o m p a r i n g   f o r   a   n o n - e m p t y   s t r i n g ,   t h e   c o n s i d e r i n g   b l o c k   * m u s t *   b e   u s e d . 
 
 -   W h e n   p e r f o r m i n g   c o m p a r i s o n s   u s i n g   < ,"d , > ,"e   o p e r a t o r s   o r   c o n c a t e n a t i n g   v a l u e s   w i t h   &   o p e r a t o r ,   i t   i s   * e s s e n t i a l *   t o   e n s u r e   t h e   l e f t   o p e r a n d   i s   o f   t h e   c o r r e c t   t y p e   ( n u m b e r / t e x t / d a t e / l i s t )   a s   A S   w i l l   c o e r c e   t h e   R H   o p e r a n d   t o   t h e   s a m e   t y p e   a s   t h e   L H   o p e r a n d ,   a n d   i n   s o m e   c a s e s   e v e n   c a s t s   * b o t h *   ( e . g .   ` 1 & 2 ` - > ` { 1 } & { 2 } ` - > ` { 1 , 2 } ` ) .   C o n v e r s e l y ,   w h e n   u s i n g   = /"`   o p e r a t o r s ,   i f   t h e   t w o   o p e r a n d s   a r e   n o t   t h e   s a m e   t y p e   t h e n   t h i s   w i l l   a l m o s t   a l w a y s   r e s u l t   i n   ` f a l s e `   ( t h e   o b v i o u s   e x c e p t i o n   b e i n g   i n t e g e r / r e a l   c o m p a r i s o n s ,   e . g .   ` 1 = 1 . 0 ` - > t r u e ) ,   e v e n   t h o u g h   t y p e - o n l y   d i f f e r e n c e s   a r e   o f t e n   i g n o r e d   b y   o t h e r   o p e r a t o r s / c o m m a n d s   ( e . g .   ` 1 < " 1 " - > f a l s e ,   ` 1 < { 1 } ` - > f a l s e ) .   F u l l y   s a n i t i z i n g   a l l   h a n d l e r   p a r a m e t e r s   b e f o r e   u s i n g   t h e m   s h o u l d   g e n e r a l l y   a v o i d   s u c h   p r o b l e m s   s u b s e q u e n t l y   m a n i f e s t i n g   i n   t h e   h a n d l e r ,   b u t   e t e r n a l   v i g i l a n c e   i s   s t i l l   r e q u i r e d   t o   e n s u r e   e x t r e m e l y   o b s c u r e / n a s t y / u n p r e d i c t a b l e / a l m o s t - i m p o s s i b l e - t o - t r o u b l e s h o o t   b u g s   d o n ' t   s n e a k   i n . 
 
 T O   D O : 
 
 -   e l i m i n a t e   S D E F   t e r m i n o l o g y   f o r   ` n a t i v e   t y p e ` ,   ` c h e c k   t y p e ` ,   a n d   ` c o n v e r t   t o   C o c o a `   c o m m a n d s   a n d   u s e   i d e n t i f i e r - b a s e d   n a m e s   i n s t e a d ?   T h i s   w o u l d   b e   c o n s i s t e n t   w i t h   r e s t   o f   l i b r a r y ' s   h a n d l e r s ,   a n d   a v o i d   t h e   o b v i o u s   g o t c h a   w h e r e   u s e r   f o r g e t s   t o   i n c l u d e   p a r a m e t e r   n a m e   i n   c o m m a n d   a n d   p a s s e s   v a l u e   a s   d i r e c t   p a r a m e t e r   i n s t e a d   c o m m a n d   ( w h i c h   i s   d i s a l l o w e d   h e r e   s i n c e   t h e   v a l u e   c a n   b e   a n y t h i n g ,   i n c l u d i n g   s c r i p t   o b j e c t s   w h i c h   a r e n ' t   s u i t a b l e   a s   d i r e c t   p a r a m e t e r s   t o   k e y w o r d - b a s e d   c o m m a n d s   d u e   t o   A S ' s   e c c e n t r i c   d i s p a t c h   r u l e s ) .   A l t e r n a t i v e l y ,   c o u l d   d e f i n e   ` c o n v e r t   t o   T Y P E `   t e r m i n o l o g y   f o r   a l l   ` a s T Y P E P a r a m e t e r `   c o m m a n d s ,   w h i c h   i s   h a n d y   f o r   o p t i o n a l   p a r a m s   ( e . g .   p a r a m e t e r   n a m e   c o u l d   b e   o p t i o n a l ;   i f   o m i t t e d ,   g e n e r a t e s   d i f f e r e n t   e r r o r   m e s s a g e ) .   e . g .   ` c o n v e r t   t o   t e x t   f r o m   t h e V a l u e   f o r   p a r a m e t e r   " u s i n g " ` 
 
 
 -   i n   ` c h e c k   t y p e ` ,   h o w   t o   p r o v i d e   o p t i o n   f o r   c h e c k i n g   i f   v a l u e   i s   a   * l i s t *   o f   t h e   s p e c i f i e d   t y p e ?   o n e   o p t i o n   w o u l d   b e   t o   p r o v i d e   b o t h   ` i s `   a n d   ` i s   l i s t   o f `   p a r a m e t e r s   o n   ` c h e c k   t y p e ` ;   a n o t h e r   w o u l d   b e   t o   p r o v i d e   a   s e p a r a t e   ` c h e c k   i t e m   t y p e   f o r   L I S T   i s   T Y P E `   c o m m a n d .   
 
 	 ( N o t e   t h a t   c h e c k i n g   i f   v a l u e   i s   a   r e c o r d   o f   s p e c i f i c   f o r m ,   e . g .   ` { n a m e : t e x t ,   i s D o n e : b o o l e a n } ` ,   i s   i m p r a c t i c a l   d u e   t o   t h e   l a c k   o f   A S   i n t r o s p e c t i o n   a n d   t h e   i n a b i l i t y   o f   A S O C ' s   r e c o r d - t o - N S D i c t i o n a r y   c o n v e r s i o n   t o   p r e s e r v e   k e y w o r d   b a s e d   n a m e s ,   t h e r e f o r e   i t ' s   n o t   w o r t h   t r y i n g   t o   i m p l e m e n t   t h a t . ) 
 	 
 	 ( B e   a w a r e   t h a t   w h i l e   t h e   ` c o u n t `   c o m m a n d ' s   ` e a c h `   p a r a m e t e r   c l a i m s   t o   a c c e p t   a   l i s t   o f   t y p e   c l a s s e s ,   t h i s   i s   n o   g o o d   f o r   a c t u a l l y   d e t e r m i n i n g   i f   a l l   l i s t   i t e m s   a r e   o n e   o f   t h o s e   t y p e s .   I t   l o o k s   l i k e   w h e n   a   l i s t   i s   g i v e n   i t   a c t u a l l y   c o u n t s   a l l   t h e   v a l u e s   t h a t   c a n   b e   _ c o e r c e d _   o n e   o f   s p e c i f i e d   t y p e s   ( a s   p e r   ` a s `   o p e r a t o r   e n h a n c e m e n t   i n   1 0 . 1 0 ) ,   n o t   w h e t h e r   t h e   v a l u e   i s   a c t u a l l y   o n e   o f   t h o s e   t y p e s .   T h u s   w h e n   c h e c k i n g   a   l i s t   f o r   m u l t i p l e   t y p e s ,   i t ' s   n e c e s s a r y   t o   c h e c k   e a c h   i t e m   a g a i n s t   e a c h   t y p e   O ( n m ) ,   a s   i t ' s   p o s s i b l e   f o r   t w o   t y p e   n a m e s   t o   m a t c h   t h e   s a m e   i t e m   ( e . g .   c o u n t i n g   e a c h   ` i n t e g e r ` ,   t h e n   e a c h   ` r e a l ` ,   t h e n   e a c h   ` t e x t `   a n d   s u m m i n g   t h e   r e s u l t   s h o u l d   b e   o k ,   b u t   c o u n t i n g   e a c h   ` i n t e g e r ` ,   t h e n   e a c h   ` n u m b e r ` ,   t h e n   e a c h   ` r e a l `   w o u l d   r e s u l t   i n   a l l   i n t e g e r   a n d   r e a l   i t e m s   b e i n g   c o u n t e d   t w i c e ) ,   r e s u l t i n g   i n   a n   i n c o r r e c t   c o u n t   w h e n   t h e   s u b t o t a l s   f o r   e a c h   t i m e   a r e   f i n a l l y   a d d e d   u p .   W h i l e   A S ' s   c o l l e c t i o n   t y p e   n a m e s   i s   q u i t e   s t a b l e ,   m a k i n g   i t   t e m p t i n g   t o   h a c k   i n   s p e c i a l - c a s e   c h e c k s   t o   p r e v e n t   s u c h   o v e r c o u n t s ,   i t ' s   i m p o s s i b l e   t o   g u a r a n t e e   n e w   n a m e s   w o n ' t   b e   a d d e d   i n   f u t u r e ,   s o   t h a t   i s n ' t   a   s a f e   s o l u t i o n . ) 
 
 
 -   a d d   ` c h e c k   c o e r c i o n `   h a n d l e r   t h a t   c h e c k s   i f   v a l u e   c a n   [ s a f e l y ? ]   b e   c o e r c e d   t o   t h e   s p e c i f i e d   t y p e   ( Q .   d o e s   ` c o u n t   { t h e V a l u e }   e a c h   { t h e T y p e } `   w o r k   s a m e   a s   ` t h e V a l u e   a s   { t h e T y p e } `   b y   f i r s t   t e s t i n g   f o r   e x a c t   t y p e   t h e n   t e s t i n g   f o r   c o e r c i b i l i t y ? ) 
 
 -   a d d   ` c h e c k   A p p l e S c r i p t O b j C   c l a s s `   h a n d l e r   t h a t   c h e c k s   i f   v a l u e   i s   o c i d   s p e c i f i e r   a n d   i t s   c l a s s   n a m e   i s   s p e c i f i e d   s t r i n g ? 
 
 
 -   n o t e :   m a k e   s u r e   ` a s T Y P E P a r a m e t e r `   h a n d l e r s   w i l l   a l w a y s   a c c e p t   A S O C   o b j e c t s ,   c o e r c i n g   t o   c o r r e s p o n d i n g   A S   t y p e   ( i . e .   d o n ' t   a d d   a n y   c h e c k s   t h a t ' d   c a u s e   t h e m   t o   r e j e c t   ' o c i d '   s p e c i f i e r s ) ,   e . g .   ` a s N u m b e r P a r a m e t e r `   w i l l   p r o b a b l y   c u r r e n t l y   f a i l   o n   A S O C   o b j e c t   a s   i t   d o e s n ' t   f i r s t   c o e r c e   t o   ` a n y ` ;   m i g h t   b e   b e s t   i f   a l l   ` a s T Y P E P a r a m e t e r `   h a n d l e r s   f i r s t   c o e r c e   t o   ` a n y `   b e f o r e   c o e r c i n g   t o   a c t u a l   r e q u i r e d   t y p e   ( t h e   o n l y   e x c e p t i o n   w o u l d   b e   a n   ` a s R e f e r e n c e P a r a m e t e r `   h a n d l e r ,   a s   t h a t   n e e d s   t o   t y p e c h e c k   o n l y ,   a s   c o e r c i n g   a   r e f e r e n c e   d e r e f e r e n c e s   i t ) 
 
 -   s h o u l d   a s T e x t P a r a m e t e r ( )   a l w a y s   t h r o w   a n   e r r o r   i f   v a l u e   i s   a   l i s t ?   ( i . e .   a v o i d s   i n c o n s i s t e n t   c o n c a t e n a t i o n   r e s u l t s   d u e   t o   T I D s ) ;   a n o t h e r   o p t i o n   w o u l d   b e   t o   w h i t e l i s t   s o m e   o r   a l l   k n o w n   ' s a f e '   t y p e s   ( i n t e g e r / r e a l ,   t e x t ,   d a t e ,   a l i a s / f i l e / f u r l ,   e t c )   a n d   r e j e c t   e v e r y t h i n g   e l s e ;   t h i s   s h o u l d   e n s u r e   s t a b l e   p r e d i c t a b l e   b e h a v i o r   -   e v e n   w h e r e   a d d i t i o n a l   c u s t o m   c o e r c i o n   h a n d l e r s   a r e   i n s t a l l e d   ( u s e r s   c a n   s t i l l   u s e   o t h e r   t y p e s   o f   v a l u e s ,   o f   c o u r s e ;   t h e y   j u s t   h a v e   t o   e x p l i c i t l y   c o e r c e   t h e m   f i r s t   u s i n g   ` a s `   o p e r a t o r )  
 
   -   a l s o ,   ` m i s s i n g   v a l u e `   a n d   o t h e r   t y p e / c o n s t a n t   s y m b o l s   a r e   c u r r e n t l y   a c c e p t e d   b y   a s T e x t P a r a m e t e r   ( t h o u g h   m a y   c o e r c e   t o   e i t h e r   k e y w o r d   n a m e   t e x t   o r   r a w   c h e v r o n   t e x t ,   w h i c h   m a y   b e   a   r e a s o n   f o r   ` a s T e x t P a r a m e t e r `   t o   d i s a l l o w   t h e m ;   s e e   a l s o   h a n d l i n g   o f   m o n t h   a n d   w e e k d a y   c o n s t a n t s   i n   ` a s I n t e g e r / R e a l / N u m b e r P a r a m e t e r ` )   s o   w i l l   n o t   t r i g g e r   - 1 7 0 3 ;   s c r i p t   o b j e c t s ,   a p p   r e f s ,   e t c .   w i l l   t r i g g e r   - 1 7 0 8   d u e   t o   d i r e c t   p a r a m e t e r   d i s p a t c h   ( i . e .   ` u p p e r c a s e   t e x t `   g e t s   d i s p a t c h e d   t o   t h e m   i n s t e a d   o f   T e x t )    
 
 
 
 -   s h o u l d   ` a s [ I n t e g e r / R e a l / N u m b e r ] P a r a m e t e r `   h a n d l e r s   e x p l i c i t l y   c h e c k   f o r   a n d   r e j e c t   n o n - n u m b e r - l i k e   v a l u e s   t h a t   A S   w o u l d   n o r m a l l y   c o e r c e   t o   n u m b e r s ?   P r o b a b l y ,   e . g .   j u s t   b e c a u s e   J a n u a r y . . D e c e m b e r   a n d   M o n d a y . . S u n d a y   c o n s t a n t s   _ c a n _   c o e r c e   d o e s n ' t   m e a n   t h e y   s h o u l d ,   a s   i f   t h e y ' r e   b e i n g   p a s s e d   t o   a   h a n d l e r   t h a t   e x p e c t s   a   r e g u l a r   n u m b e r   t h e n   i t   a l m o s t   c e r t a i n l y   i n d i c a t e s   a   m i s t a k e   i n   t h e   u s e r ' s   c o d e   t h a t   s h o u l d   b e   d r a w n   t o   h e r   a t t e n t i o n .   F o r   e x a m p l e ,   u s i n g   S t a n d a r d   A d d i t i o n s : 
 
 	 r a n d o m   n u m b e r   f r o m   J a n u a r y   t o   D e c e m b e r   - - >   0 . 0 - 1 . 0   ( w r o n g !   t h i s   i s   a   b u g   i n   ` r a n d o m   n u m b e r `   o s a x   h a n d l e r   w h e r e   i t   s i l e n t l y   i g n o r e s   n o n - n u m e r i c   p a r a m e t e r   t y p e s   i n s t e a d   o f   r e p o r t i n g   c o e r c i o n   e r r o r )   	 r a n d o m   n u m b e r   f r o m   ( J a n u a r y   a s   i n t e g e r )   t o   ( D e c e m b e r   a s   i n t e g e r )   - - >   1 - 1 2 
 	 
 	 ( C a v e a t :   s e e   a b o v e   a b o u t   n o t   r e j e c t i n g   A S O C   o b j e c t s .   W i l l   n e e d   t o   b e   c a r e f u l   t o   a l l o w   N S N u m b e r / N S S t r i n g ,   t h o u g h   n o t   N S A p p l e E v e n t D e s c r i p t o r ) 
 
   
  
 l     ��������  ��  ��        x     �� ����    4    �� 
�� 
frmk  m       �    F o u n d a t i o n��        l     ��������  ��  ��        l     ��  ��    J D--------------------------------------------------------------------     �   � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -      l     ��  ��    9 3 check if a handler exists before trying to call it     �   f   c h e c k   i f   a   h a n d l e r   e x i s t s   b e f o r e   t r y i n g   t o   c a l l   i t      l     ��������  ��  ��       !   l     �� " #��   "VP used to check for the existence of an optional 'callback' handler before calling it, as AS doesn't distinguish between an error -1708 that occurs because handler wasn't defined (in which case don't call it) and an error -1708 that occurs because the handler was found but went on to call another handler that doesn't exist (i.e. a bug)    # � $ $�   u s e d   t o   c h e c k   f o r   t h e   e x i s t e n c e   o f   a n   o p t i o n a l   ' c a l l b a c k '   h a n d l e r   b e f o r e   c a l l i n g   i t ,   a s   A S   d o e s n ' t   d i s t i n g u i s h   b e t w e e n   a n   e r r o r   - 1 7 0 8   t h a t   o c c u r s   b e c a u s e   h a n d l e r   w a s n ' t   d e f i n e d   ( i n   w h i c h   c a s e   d o n ' t   c a l l   i t )   a n d   a n   e r r o r   - 1 7 0 8   t h a t   o c c u r s   b e c a u s e   t h e   h a n d l e r   w a s   f o u n d   b u t   w e n t   o n   t o   c a l l   a n o t h e r   h a n d l e r   t h a t   d o e s n ' t   e x i s t   ( i . e .   a   b u g ) !  % & % l     ��������  ��  ��   &  ' ( ' l     �� ) *��   )93 CAUTION: `hasHander` relies on AS handlers' partial ability to behave as AS objects in that they can be retrieved by name, assigned to variables, and coerced to `handler` type. Be aware, however, this object-like behavior is undocumented and essentially undefined: AS handlers are not closures, so moving them around will completely break their lexical and dynamic bindings, causing seriously bizarre and incorrect behavior if subsequently called. The only reason `hasHandler` resorts to such hackery because AS lacks the introspection/stack trace capabilites to do the job right (either by asking the containing script object to describe its contents, or by calling the handler speculatively then examining the stack trace to determine if error -1708 was due to the handler not existing or a bug occurring within it).    * � + +f   C A U T I O N :   ` h a s H a n d e r `   r e l i e s   o n   A S   h a n d l e r s '   p a r t i a l   a b i l i t y   t o   b e h a v e   a s   A S   o b j e c t s   i n   t h a t   t h e y   c a n   b e   r e t r i e v e d   b y   n a m e ,   a s s i g n e d   t o   v a r i a b l e s ,   a n d   c o e r c e d   t o   ` h a n d l e r `   t y p e .   B e   a w a r e ,   h o w e v e r ,   t h i s   o b j e c t - l i k e   b e h a v i o r   i s   u n d o c u m e n t e d   a n d   e s s e n t i a l l y   u n d e f i n e d :   A S   h a n d l e r s   a r e   n o t   c l o s u r e s ,   s o   m o v i n g   t h e m   a r o u n d   w i l l   c o m p l e t e l y   b r e a k   t h e i r   l e x i c a l   a n d   d y n a m i c   b i n d i n g s ,   c a u s i n g   s e r i o u s l y   b i z a r r e   a n d   i n c o r r e c t   b e h a v i o r   i f   s u b s e q u e n t l y   c a l l e d .   T h e   o n l y   r e a s o n   ` h a s H a n d l e r `   r e s o r t s   t o   s u c h   h a c k e r y   b e c a u s e   A S   l a c k s   t h e   i n t r o s p e c t i o n / s t a c k   t r a c e   c a p a b i l i t e s   t o   d o   t h e   j o b   r i g h t   ( e i t h e r   b y   a s k i n g   t h e   c o n t a i n i n g   s c r i p t   o b j e c t   t o   d e s c r i b e   i t s   c o n t e n t s ,   o r   b y   c a l l i n g   t h e   h a n d l e r   s p e c u l a t i v e l y   t h e n   e x a m i n i n g   t h e   s t a c k   t r a c e   t o   d e t e r m i n e   i f   e r r o r   - 1 7 0 8   w a s   d u e   t o   t h e   h a n d l e r   n o t   e x i s t i n g   o r   a   b u g   o c c u r r i n g   w i t h i n   i t ) . (  , - , l     ��������  ��  ��   -  . / . l     �� 0 1��   0 � � CAUTION: `hasHandler` only works for handlers with identifier-based names; do not use to check for existence of handlers with keyword-based names as that will result in incorrect behavior.    1 � 2 2z   C A U T I O N :   ` h a s H a n d l e r `   o n l y   w o r k s   f o r   h a n d l e r s   w i t h   i d e n t i f i e r - b a s e d   n a m e s ;   d o   n o t   u s e   t o   c h e c k   f o r   e x i s t e n c e   o f   h a n d l e r s   w i t h   k e y w o r d - b a s e d   n a m e s   a s   t h a t   w i l l   r e s u l t   i n   i n c o r r e c t   b e h a v i o r . /  3 4 3 l     ��������  ��  ��   4  5 6 5 i    7 8 7 I      �� 9���� 0 
hashandler 
hasHandler 9  :�� : o      ���� 0 
handlerref 
handlerRef��  ��   8 l     ; < = ; Q      > ? @ > l   	 A B C A k    	 D D  E F E l    G H I G c     J K J o    ���� 0 
handlerref 
handlerRef K m    ��
�� 
hand H ? 9 dereference and type check; this raises -1700 on failure    I � L L r   d e r e f e r e n c e   a n d   t y p e   c h e c k ;   t h i s   r a i s e s   - 1 7 0 0   o n   f a i l u r e F  M�� M L    	 N N m    ��
�� boovtrue��   B G A horrible hack to check if a script object has a specific handler    C � O O �   h o r r i b l e   h a c k   t o   c h e c k   i f   a   s c r i p t   o b j e c t   h a s   a   s p e c i f i c   h a n d l e r ? R      ���� P
�� .ascrerr ****      � ****��   P �� Q��
�� 
errn Q d       R R m      �������   @ l    S T U S L     V V m    ��
�� boovfals T K E the referred-to script object slot doesn't exist, or isn't a handler    U � W W �   t h e   r e f e r r e d - t o   s c r i p t   o b j e c t   s l o t   d o e s n ' t   e x i s t ,   o r   i s n ' t   a   h a n d l e r < < 6 handlerRef must be `a reference to HANDLER of SCRIPT`    = � X X l   h a n d l e r R e f   m u s t   b e   ` a   r e f e r e n c e   t o   H A N D L E R   o f   S C R I P T ` 6  Y Z Y l     ��������  ��  ��   Z  [ \ [ l     ��������  ��  ��   \  ] ^ ] l     �� _ `��   _ J D--------------------------------------------------------------------    ` � a a � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ^  b c b l     �� d e��   d � � convenience handlers for raising common errors; using these improves consistency, ensuring all error messages and parameters follow same general structure, and that all library handlers automatically benefit from any future improvements made here    e � f f�   c o n v e n i e n c e   h a n d l e r s   f o r   r a i s i n g   c o m m o n   e r r o r s ;   u s i n g   t h e s e   i m p r o v e s   c o n s i s t e n c y ,   e n s u r i n g   a l l   e r r o r   m e s s a g e s   a n d   p a r a m e t e r s   f o l l o w   s a m e   g e n e r a l   s t r u c t u r e ,   a n d   t h a t   a l l   l i b r a r y   h a n d l e r s   a u t o m a t i c a l l y   b e n e f i t   f r o m   a n y   f u t u r e   i m p r o v e m e n t s   m a d e   h e r e c  g h g l     ��������  ��  ��   h  i j i i    k l k I      �� m���� .0 throwinvalidparameter throwInvalidParameter m  n o n o      ���� 0 thevalue theValue o  p q p o      ���� 0 parametername parameterName q  r s r o      ���� 0 expectedtype expectedType s  t�� t o      ���� $0 errordescription errorDescription��  ��   l k     ( u u  v w v Z      x y�� z x =      { | { n     } ~ } 1    ��
�� 
leng ~ o     ���� 0 parametername parameterName | m    ����   y r      �  m    	 � � � � �  d i r e c t � o      ���� 0 parametername parameterName��   z r     � � � b     � � � b     � � � m     � � � � �   � o    ���� 0 parametername parameterName � m     � � � � �   � o      ���� 0 parametername parameterName w  ��� � R    (�� � �
�� .ascrerr ****      � **** � b    ' � � � b    % � � � b    # � � � b    ! � � � m     � � � � �  I n v a l i d   � o     ���� 0 parametername parameterName � m   ! " � � � � �    p a r a m e t e r   ( � o   # $���� $0 errordescription errorDescription � m   % & � � � � �  ) . � �� � �
�� 
errn � m    �����Y � �� � �
�� 
erob � o    ���� 0 thevalue theValue � �� ���
�� 
errt � m    ��
�� 
enum��  ��   j  � � � l     ��������  ��  ��   �  � � � l     ��������  ��  ��   �  � � � i    � � � I      �� ����� 60 throwinvalidparametertype throwInvalidParameterType �  � � � o      ���� 0 thevalue theValue �  � � � o      ���� 0 parametername parameterName �  � � � o      ���� $0 expectedtypename expectedTypeName �  ��� � o      ���� 0 expectedtype expectedType��  ��   � k     7 � �  � � � Q     ) � � � � Z     � ��� � � >     � � � l    ����� � I   �� � �
�� .corecnte****       **** � J     � �  ��� � o    ���� 0 thevalue theValue��   � �� ���
�� 
kocl � m    ��
�� 
obj ��  ��  ��   � m    ����   � r     � � � m     � � � � � .   b u t   r e c e i v e d   s p e c i f i e r � o      ����  0 actualtypename actualTypeName��   � l    � � � � r     � � � b     � � � m     � � � � �    b u t   r e c e i v e d   � l    ����� � n    � � � m    ��
�� 
pcls � o    ���� 0 thevalue theValue��  ��   � o      ����  0 actualtypename actualTypeName � include the value's type name in error message; note: this will display as raw four-char code when terminology isn't available, or may be a custom value in the case of records and scripts, but this can't be helped as it's a limitation of AppleScript itself    � � � �   i n c l u d e   t h e   v a l u e ' s   t y p e   n a m e   i n   e r r o r   m e s s a g e ;   n o t e :   t h i s   w i l l   d i s p l a y   a s   r a w   f o u r - c h a r   c o d e   w h e n   t e r m i n o l o g y   i s n ' t   a v a i l a b l e ,   o r   m a y   b e   a   c u s t o m   v a l u e   i n   t h e   c a s e   o f   r e c o r d s   a n d   s c r i p t s ,   b u t   t h i s   c a n ' t   b e   h e l p e d   a s   i t ' s   a   l i m i t a t i o n   o f   A p p l e S c r i p t   i t s e l f � R      ������
�� .ascrerr ****      � ****��  ��   � r   & ) � � � m   & ' � � � � �   � o      ����  0 actualtypename actualTypeName �  ��� � I   * 7�� ����� .0 throwinvalidparameter throwInvalidParameter �  � � � o   + ,���� 0 thevalue theValue �  � � � o   , -���� 0 parametername parameterName �  � � � o   - .���� 0 expectedtype expectedType �  ��� � b   . 3 � � � b   . 1 � � � m   . / � � � � �  e x p e c t e d   � o   / 0���� $0 expectedtypename expectedTypeName � o   1 2����  0 actualtypename actualTypeName��  ��  ��   �  � � � l     ��������  ��  ��   �  � � � l     ��������  ��  ��   �  � � � i    � � � I      �� ����� >0 throwinvalidparameterconstant throwInvalidParameterConstant �  � � � o      �� 0 thevalue theValue �  ��~ � o      �}�} 0 parametername parameterName�~  ��   � I     	�| ��{�| .0 throwinvalidparameter throwInvalidParameter �  � � � o    �z�z 0 thevalue theValue �  � � � o    �y�y 0 parametername parameterName �  � � � m    �x
�x 
enum �  ��w � m     � � � � � . n o t   a n   a l l o w e d   c o n s t a n t�w  �{   �  � � � l     �v�u�t�v  �u  �t   �    l     �s�r�q�s  �r  �q    l     �p�o�n�p  �o  �n    l     �m�l�k�m  �l  �k    l     �j�i�h�j  �i  �h   	 i   

 I      �g�f�g 0 rethrowerror rethrowError  o      �e�e 0 libraryname libraryName  o      �d�d 0 handlername handlerName  o      �c�c 0 etext eText  o      �b�b 0 enumber eNumber  o      �a�a 0 efrom eFrom  o      �`�` 
0 eto eTo  o      �_�_ $0 targetobjectname targetObjectName �^ o      �]�] 0 partialresult partialResult�^  �f   l    = k     =  !  l     �\"#�\  " E ? TO DO: would it be useful to put error attributes into record?   # �$$ ~   T O   D O :   w o u l d   i t   b e   u s e f u l   t o   p u t   e r r o r   a t t r i b u t e s   i n t o   r e c o r d ?! %&% r     '(' b     	)*) b     +,+ b     -.- b     /0/ o     �[�[ 0 libraryname libraryName0 m    11 �22    c a n  t  . o    �Z�Z 0 handlername handlerName, m    33 �44  :  * o    �Y�Y 0 etext eText( o      �X�X 0 etext eText& 565 Z   78�W�V7 >   9:9 o    �U�U $0 targetobjectname targetObjectName: m    �T
�T 
msng8 r    ;<; b    =>= b    ?@? o    �S�S $0 targetobjectname targetObjectName@ m    AA �BB    o f  > o    �R�R 0 etext eText< o      �Q�Q 0 etext eText�W  �V  6 C�PC Z    =DE�OFD =   !GHG o    �N�N 0 partialresult partialResultH m     �M
�M 
msngE R   $ .�LIJ
�L .ascrerr ****      � ****I o   , -�K�K 0 etext eTextJ �JKL
�J 
errnK o   & '�I�I 0 enumber eNumberL �HMN
�H 
erobM o   ( )�G�G 0 efrom eFromN �FO�E
�F 
errtO o   * +�D�D 
0 eto eTo�E  �O  F R   1 =�CPQ
�C .ascrerr ****      � ****P o   ; <�B�B 0 etext eTextQ �ARS
�A 
errnR o   3 4�@�@ 0 enumber eNumberS �?TU
�? 
erobT o   5 6�>�> 0 efrom eFromU �=VW
�= 
errtV o   7 8�<�< 
0 eto eToW �;X�:
�; 
ptlrX o   9 :�9�9 0 partialresult partialResult�:  �P   ~ x targetObjectName and partialResult should be `missing value` if unused; if eTo is unused, AS seems to be to pass `item`    �YY �   t a r g e t O b j e c t N a m e   a n d   p a r t i a l R e s u l t   s h o u l d   b e   ` m i s s i n g   v a l u e `   i f   u n u s e d ;   i f   e T o   i s   u n u s e d ,   A S   s e e m s   t o   b e   t o   p a s s   ` i t e m `	 Z[Z l     �8�7�6�8  �7  �6  [ \]\ l     �5�4�3�5  �4  �3  ] ^_^ l     �2`a�2  ` � � convenience shortcuts for rethrowError() when targetObjectName and/or partialResult parameters aren't used (since AS handlers don't support optional parameters unless SDEFs are used, which only creates more complexity and challenges)   a �bb�   c o n v e n i e n c e   s h o r t c u t s   f o r   r e t h r o w E r r o r ( )   w h e n   t a r g e t O b j e c t N a m e   a n d / o r   p a r t i a l R e s u l t   p a r a m e t e r s   a r e n ' t   u s e d   ( s i n c e   A S   h a n d l e r s   d o n ' t   s u p p o r t   o p t i o n a l   p a r a m e t e r s   u n l e s s   S D E F s   a r e   u s e d ,   w h i c h   o n l y   c r e a t e s   m o r e   c o m p l e x i t y   a n d   c h a l l e n g e s )_ cdc l     �1�0�/�1  �0  �/  d efe i   "ghg I      �.i�-�. &0 throwcommanderror throwCommandErrori jkj o      �,�, 0 libraryname libraryNamek lml o      �+�+ 0 handlername handlerNamem non o      �*�* 0 etext eTexto pqp o      �)�) 0 enumber eNumberq rsr o      �(�( 0 efrom eFroms t�'t o      �&�& 
0 eto eTo�'  �-  h R     �%u�$
�% .ascrerr ****      � ****u I    �#v�"�# 0 rethrowerror rethrowErrorv wxw o    �!�! 0 libraryname libraryNamex yzy o    � �  0 handlername handlerNamez {|{ o    �� 0 etext eText| }~} o    �� 0 enumber eNumber~ � o    �� 0 efrom eFrom� ��� o    	�� 
0 eto eTo� ��� m   	 
�
� 
msng� ��� m   
 �
� 
msng�  �"  �$  f ��� l     ����  �  �  � ��� l     ����  �  �  � ��� i  # &��� I      ���� $0 throwmethoderror throwMethodError� ��� o      �� 0 libraryname libraryName� ��� o      �� $0 targetobjectname targetObjectName� ��� o      �� 0 handlername handlerName� ��� o      �� 0 etext eText� ��� o      �� 0 enumber eNumber� ��� o      �� 0 efrom eFrom� ��
� o      �	�	 
0 eto eTo�
  �  � R     ���
� .ascrerr ****      � ****� I    ���� 0 rethrowerror rethrowError� ��� o    �� 0 libraryname libraryName� ��� o    �� 0 handlername handlerName� ��� o    �� 0 etext eText� ��� o    �� 0 enumber eNumber� ��� o    � �  0 efrom eFrom� ��� o    	���� 
0 eto eTo� ��� o   	 
���� $0 targetobjectname targetObjectName� ���� m   
 ��
�� 
msng��  �  �  � ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� l     ������  � J D--------------------------------------------------------------------   � ��� � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -� ��� l     ������  �rl convenience handlers for coercing parameters to commonly-used AppleScript types, throwing a descriptive error if the coercion fails; use these to ensure parameters to library handlers are of the correct type (while AS handlers allow parameters to be directly annotated with `as TYPE` clauses, these are limited in capability and do not produce descriptive errors)   � ����   c o n v e n i e n c e   h a n d l e r s   f o r   c o e r c i n g   p a r a m e t e r s   t o   c o m m o n l y - u s e d   A p p l e S c r i p t   t y p e s ,   t h r o w i n g   a   d e s c r i p t i v e   e r r o r   i f   t h e   c o e r c i o n   f a i l s ;   u s e   t h e s e   t o   e n s u r e   p a r a m e t e r s   t o   l i b r a r y   h a n d l e r s   a r e   o f   t h e   c o r r e c t   t y p e   ( w h i l e   A S   h a n d l e r s   a l l o w   p a r a m e t e r s   t o   b e   d i r e c t l y   a n n o t a t e d   w i t h   ` a s   T Y P E `   c l a u s e s ,   t h e s e   a r e   l i m i t e d   i n   c a p a b i l i t y   a n d   d o   n o t   p r o d u c e   d e s c r i p t i v e   e r r o r s )� ��� l     ��������  ��  ��  � ��� l     ������  � � � note: AS requires `as` operator's RH operand to be literal type name, so can't be parameterized; instead, a separate as...Parameter() handler must be defined for each type (tedious, but only needs done once)   � ����   n o t e :   A S   r e q u i r e s   ` a s `   o p e r a t o r ' s   R H   o p e r a n d   t o   b e   l i t e r a l   t y p e   n a m e ,   s o   c a n ' t   b e   p a r a m e t e r i z e d ;   i n s t e a d ,   a   s e p a r a t e   a s . . . P a r a m e t e r ( )   h a n d l e r   m u s t   b e   d e f i n e d   f o r   e a c h   t y p e   ( t e d i o u s ,   b u t   o n l y   n e e d s   d o n e   o n c e )� ��� l     ��������  ��  ��  � ��� i  ' *��� I      ������� (0 asbooleanparameter asBooleanParameter� ��� o      ���� 0 thevalue theValue� ���� o      ���� 0 parametername parameterName��  ��  � Q     ���� L    �� c    ��� o    ���� 0 thevalue theValue� m    ��
�� 
bool� R      �����
�� .ascrerr ****      � ****��  � �����
�� 
errn� d      �� m      �������  � I    ������� 60 throwinvalidparametertype throwInvalidParameterType� ��� o    ���� 0 thevalue theValue� ��� o    ���� 0 parametername parameterName� ��� m    �� ���  b o o l e a n� ���� m    ��
�� 
bool��  ��  � ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� i  + .��� I      ������� (0 asintegerparameter asIntegerParameter� ��� o      ���� 0 thevalue theValue� ���� o      ���� 0 parametername parameterName��  ��  � Q     ���� l   ���� L    �� c    ��� o    ���� 0 thevalue theValue� m    ��
�� 
long� { u TO DO: error if theValue has non-zero fractional part? (AS rounds toward zero by default, i.e. discarding user data)   � ��� �   T O   D O :   e r r o r   i f   t h e V a l u e   h a s   n o n - z e r o   f r a c t i o n a l   p a r t ?   ( A S   r o u n d s   t o w a r d   z e r o   b y   d e f a u l t ,   i . e .   d i s c a r d i n g   u s e r   d a t a )� R      �����
�� .ascrerr ****      � ****��  � �����
�� 
errn� d      �� m      �������  � I    ������� 60 throwinvalidparametertype throwInvalidParameterType� ��� o    ���� 0 thevalue theValue� ��� o    ���� 0 parametername parameterName� ��� m    �� �    i n t e g e r� �� m    ��
�� 
long��  ��  �  l     ��������  ��  ��    l     ��������  ��  ��    i  / 2	 I      ��
���� "0 asrealparameter asRealParameter
  o      ���� 0 thevalue theValue �� o      ���� 0 parametername parameterName��  ��  	 Q      L     c     o    ���� 0 thevalue theValue m    ��
�� 
doub R      ����
�� .ascrerr ****      � ****��   ����
�� 
errn d       m      �������   I    ������ 60 throwinvalidparametertype throwInvalidParameterType  o    ���� 0 thevalue theValue  o    ���� 0 parametername parameterName  m     �  r e a l  ��  m    ��
�� 
doub��  ��   !"! l     ��������  ��  ��  " #$# l     ��������  ��  ��  $ %&% i  3 6'(' I      ��)���� &0 asnumberparameter asNumberParameter) *+* o      ���� 0 thevalue theValue+ ,��, o      ���� 0 parametername parameterName��  ��  ( Q     -./- L    00 c    121 o    ���� 0 thevalue theValue2 m    ��
�� 
nmbr. R      ����3
�� .ascrerr ****      � ****��  3 ��4��
�� 
errn4 d      55 m      �������  / I    ��6���� 60 throwinvalidparametertype throwInvalidParameterType6 787 o    ���� 0 thevalue theValue8 9:9 o    ���� 0 parametername parameterName: ;<; m    == �>>  n u m b e r< ?��? m    ��
�� 
nmbr��  ��  & @A@ l     ��������  ��  ��  A BCB l     ��������  ��  ��  C DED i  7 :FGF I      ��H���� "0 astextparameter asTextParameterH IJI o      ���� 0 thevalue theValueJ K��K o      ���� 0 parametername parameterName��  ��  G l    LMNL Q     OPQO L    RR c    STS o    ���� 0 thevalue theValueT m    ��
�� 
ctxtP R      ����U
�� .ascrerr ****      � ****��  U ��V��
�� 
errnV d      WW m      �������  Q I    ��X��� 60 throwinvalidparametertype throwInvalidParameterTypeX YZY o    �~�~ 0 thevalue theValueZ [\[ o    �}�} 0 parametername parameterName\ ]^] m    __ �``  t e x t^ a�|a m    �{
�{ 
ctxt�|  �  M � TO DO: should lists be rejected for safety? (while coercing numbers and dates to text is at least predictable within a process's lifetime, coercing list to text is dependent on whatever TIDs are set at the time so can't be guaranteed even to do that)   N �bb�   T O   D O :   s h o u l d   l i s t s   b e   r e j e c t e d   f o r   s a f e t y ?   ( w h i l e   c o e r c i n g   n u m b e r s   a n d   d a t e s   t o   t e x t   i s   a t   l e a s t   p r e d i c t a b l e   w i t h i n   a   p r o c e s s ' s   l i f e t i m e ,   c o e r c i n g   l i s t   t o   t e x t   i s   d e p e n d e n t   o n   w h a t e v e r   T I D s   a r e   s e t   a t   t h e   t i m e   s o   c a n ' t   b e   g u a r a n t e e d   e v e n   t o   d o   t h a t )E cdc l     �z�y�x�z  �y  �x  d efe l     �w�v�u�w  �v  �u  f ghg i  ; >iji I      �tk�s�t "0 asdateparameter asDateParameterk lml o      �r�r 0 thevalue theValuem n�qn o      �p�p 0 parametername parameterName�q  �s  j Q     opqo l   rstr L    uu c    vwv o    �o�o 0 thevalue theValuew m    �n
�n 
ldt s71 note that this fails for anything except date or NSDate (while it would be possible to try `date theValue` as well, it's probably best not to as AS's text-to-date conversion is locale-sensitive, so an ambiguous date string such as "12/11/10" would produce unpredictable results rather than fail outright)   t �xxb   n o t e   t h a t   t h i s   f a i l s   f o r   a n y t h i n g   e x c e p t   d a t e   o r   N S D a t e   ( w h i l e   i t   w o u l d   b e   p o s s i b l e   t o   t r y   ` d a t e   t h e V a l u e `   a s   w e l l ,   i t ' s   p r o b a b l y   b e s t   n o t   t o   a s   A S ' s   t e x t - t o - d a t e   c o n v e r s i o n   i s   l o c a l e - s e n s i t i v e ,   s o   a n   a m b i g u o u s   d a t e   s t r i n g   s u c h   a s   " 1 2 / 1 1 / 1 0 "   w o u l d   p r o d u c e   u n p r e d i c t a b l e   r e s u l t s   r a t h e r   t h a n   f a i l   o u t r i g h t )p R      �m�ly
�m .ascrerr ****      � ****�l  y �kz�j
�k 
errnz d      {{ m      �i�i��j  q I    �h|�g�h 60 throwinvalidparametertype throwInvalidParameterType| }~} o    �f�f 0 thevalue theValue~ � o    �e�e 0 parametername parameterName� ��� m    �� ���  d a t e� ��d� m    �c
�c 
ldt �d  �g  h ��� l     �b�a�`�b  �a  �`  � ��� l     �_�^�]�_  �^  �]  � ��� i  ? B��� I      �\��[�\ "0 aslistparameter asListParameter� ��Z� o      �Y�Y 0 thevalue theValue�Z  �[  � k     �� ��� l     �X���X  � � � TO DO: this needs to check for an ASOC specifier to an NSArray and, if found, coerce it to AS list (currently wraps it in an AS list, which is wrong)   � ���,   T O   D O :   t h i s   n e e d s   t o   c h e c k   f o r   a n   A S O C   s p e c i f i e r   t o   a n   N S A r r a y   a n d ,   i f   f o u n d ,   c o e r c e   i t   t o   A S   l i s t   ( c u r r e n t l y   w r a p s   i t   i n   a n   A S   l i s t ,   w h i c h   i s   w r o n g )� ��� l     �W���W  �ic a more robust alternative to `theValue as list` that handles records correctly, e.g. `asListParameter({a:1,b:2})` returns `{{a:1,b:2}}` instead of `{1,2}` (AS's record-to-list coercion handler stupidly strips the record's keys, returning just its values, whereas its other TYPE-to-list coercion handlers simply wrap non-list values as a single-item list)   � ����   a   m o r e   r o b u s t   a l t e r n a t i v e   t o   ` t h e V a l u e   a s   l i s t `   t h a t   h a n d l e s   r e c o r d s   c o r r e c t l y ,   e . g .   ` a s L i s t P a r a m e t e r ( { a : 1 , b : 2 } ) `   r e t u r n s   ` { { a : 1 , b : 2 } } `   i n s t e a d   o f   ` { 1 , 2 } `   ( A S ' s   r e c o r d - t o - l i s t   c o e r c i o n   h a n d l e r   s t u p i d l y   s t r i p s   t h e   r e c o r d ' s   k e y s ,   r e t u r n i n g   j u s t   i t s   v a l u e s ,   w h e r e a s   i t s   o t h e r   T Y P E - t o - l i s t   c o e r c i o n   h a n d l e r s   s i m p l y   w r a p   n o n - l i s t   v a l u e s   a s   a   s i n g l e - i t e m   l i s t )� ��� l     �V���V  � � � note that unlike other as...Parameter handlers this doesn't take a parameterName parameter as it should never fail as *any* value can be successfully converted to a one-item list   � ���f   n o t e   t h a t   u n l i k e   o t h e r   a s . . . P a r a m e t e r   h a n d l e r s   t h i s   d o e s n ' t   t a k e   a   p a r a m e t e r N a m e   p a r a m e t e r   a s   i t   s h o u l d   n e v e r   f a i l   a s   * a n y *   v a l u e   c a n   b e   s u c c e s s f u l l y   c o n v e r t e d   t o   a   o n e - i t e m   l i s t� ��� l     �U���U  �
 caution: if the value is a list, it is returned as-is; handlers should not modify user-supplied lists in-place (unless that is an explicitly documented feature), but instead shallow copy it when needed, e.g. `set theListCopy to items of asListParameter(theList,"")`   � ���   c a u t i o n :   i f   t h e   v a l u e   i s   a   l i s t ,   i t   i s   r e t u r n e d   a s - i s ;   h a n d l e r s   s h o u l d   n o t   m o d i f y   u s e r - s u p p l i e d   l i s t s   i n - p l a c e   ( u n l e s s   t h a t   i s   a n   e x p l i c i t l y   d o c u m e n t e d   f e a t u r e ) ,   b u t   i n s t e a d   s h a l l o w   c o p y   i t   w h e n   n e e d e d ,   e . g .   ` s e t   t h e L i s t C o p y   t o   i t e m s   o f   a s L i s t P a r a m e t e r ( t h e L i s t , " " ) `� ��T� Z     ���S�� =     ��� l    	��R�Q� I    	�P��
�P .corecnte****       ****� J     �� ��O� o     �N�N 0 thevalue theValue�O  � �M��L
�M 
kocl� m    �K
�K 
list�L  �R  �Q  � m   	 
�J�J  � L    �� J    �� ��I� o    �H�H 0 thevalue theValue�I  �S  � L    �� o    �G�G 0 thevalue theValue�T  � ��� l     �F�E�D�F  �E  �D  � ��� l     �C�B�A�C  �B  �A  � ��� i  C F��� I      �@��?�@ &0 asrecordparameter asRecordParameter� ��� o      �>�> 0 thevalue theValue� ��=� o      �<�< 0 parametername parameterName�=  �?  � k     �� ��� l      �;���;  ���
TO DO: variant of this that also accepts defaultRecord parameter, merging the two and checking for any missing properties; simplest way to do that is for defaultRecord to use RequiredValue placeholder, coerce to list, and look for that)

e.g. from TestTool's TestSupport sub-library (although this makes some case-specific assumptions that won't work for a general-purpose solution):

to normalizeExpectedErrorRecord(errorRecord) -- ensure error info record has all the correct properties and that at least one of them is populated	-- make sure errorRecord contains at least one valid property and no invalid ones (note: this uses NoValue placeholders so isn't suitable for sending out of current AS instance)	if errorRecord's length = 0 then error "Invalid �is� parameter (error record contained no properties)." number -1703 from errorRecord to record	set normalizedRecord to errorRecord & _defaultErrorRecord	if normalizedRecord's length � _defaultErrorRecord's length then error "Invalid �is� parameter (error record contained unrecognized properties)." number -1703 from errorRecord to record	return normalizedRecordend normalizeExpectedErrorRecord
   � ���	 
 T O   D O :   v a r i a n t   o f   t h i s   t h a t   a l s o   a c c e p t s   d e f a u l t R e c o r d   p a r a m e t e r ,   m e r g i n g   t h e   t w o   a n d   c h e c k i n g   f o r   a n y   m i s s i n g   p r o p e r t i e s ;   s i m p l e s t   w a y   t o   d o   t h a t   i s   f o r   d e f a u l t R e c o r d   t o   u s e   R e q u i r e d V a l u e   p l a c e h o l d e r ,   c o e r c e   t o   l i s t ,   a n d   l o o k   f o r   t h a t ) 
 
 e . g .   f r o m   T e s t T o o l ' s   T e s t S u p p o r t   s u b - l i b r a r y   ( a l t h o u g h   t h i s   m a k e s   s o m e   c a s e - s p e c i f i c   a s s u m p t i o n s   t h a t   w o n ' t   w o r k   f o r   a   g e n e r a l - p u r p o s e   s o l u t i o n ) : 
 
 t o   n o r m a l i z e E x p e c t e d E r r o r R e c o r d ( e r r o r R e c o r d )   - -   e n s u r e   e r r o r   i n f o   r e c o r d   h a s   a l l   t h e   c o r r e c t   p r o p e r t i e s   a n d   t h a t   a t   l e a s t   o n e   o f   t h e m   i s   p o p u l a t e d  	 - -   m a k e   s u r e   e r r o r R e c o r d   c o n t a i n s   a t   l e a s t   o n e   v a l i d   p r o p e r t y   a n d   n o   i n v a l i d   o n e s   ( n o t e :   t h i s   u s e s   N o V a l u e   p l a c e h o l d e r s   s o   i s n ' t   s u i t a b l e   f o r   s e n d i n g   o u t   o f   c u r r e n t   A S   i n s t a n c e )  	 i f   e r r o r R e c o r d ' s   l e n g t h   =   0   t h e n   e r r o r   " I n v a l i d    i s    p a r a m e t e r   ( e r r o r   r e c o r d   c o n t a i n e d   n o   p r o p e r t i e s ) . "   n u m b e r   - 1 7 0 3   f r o m   e r r o r R e c o r d   t o   r e c o r d  	 s e t   n o r m a l i z e d R e c o r d   t o   e r r o r R e c o r d   &   _ d e f a u l t E r r o r R e c o r d  	 i f   n o r m a l i z e d R e c o r d ' s   l e n g t h  "`   _ d e f a u l t E r r o r R e c o r d ' s   l e n g t h   t h e n   e r r o r   " I n v a l i d    i s    p a r a m e t e r   ( e r r o r   r e c o r d   c o n t a i n e d   u n r e c o g n i z e d   p r o p e r t i e s ) . "   n u m b e r   - 1 7 0 3   f r o m   e r r o r R e c o r d   t o   r e c o r d  	 r e t u r n   n o r m a l i z e d R e c o r d  e n d   n o r m a l i z e E x p e c t e d E r r o r R e c o r d  
� ��:� Q     ���� L    �� c    ��� o    �9�9 0 thevalue theValue� m    �8
�8 
reco� R      �7�6�
�7 .ascrerr ****      � ****�6  � �5��4
�5 
errn� d      �� m      �3�3��4  � I    �2��1�2 60 throwinvalidparametertype throwInvalidParameterType� ��� o    �0�0 0 thevalue theValue� ��� o    �/�/ 0 parametername parameterName� ��� m    �� ���  r e c o r d� ��.� m    �-
�- 
reco�.  �1  �:  � ��� l     �,�+�*�,  �+  �*  � ��� l     �)�(�'�)  �(  �'  � ��� h   G T�&��& 0 requiredvalue RequiredValue� l     �%���%  � � � used in `asOptionalRecordParameter` command's default record, e.g. `{foo:RequiredValue, bar:missing value}` requires `foo` property is given but while `bar` property uses `missing value` if omitted   � ����   u s e d   i n   ` a s O p t i o n a l R e c o r d P a r a m e t e r `   c o m m a n d ' s   d e f a u l t   r e c o r d ,   e . g .   ` { f o o : R e q u i r e d V a l u e ,   b a r : m i s s i n g   v a l u e } `   r e q u i r e s   ` f o o `   p r o p e r t y   i s   g i v e n   b u t   w h i l e   ` b a r `   p r o p e r t y   u s e s   ` m i s s i n g   v a l u e `   i f   o m i t t e d� ��� l     �$�#�"�$  �#  �"  � ��� l     �!� ��!  �   �  � ��� i  U X��� I      ���� 60 asoptionalrecordparameter asOptionalRecordParameter� ��� o      �� 0 thevalue theValue� ��� o      �� 0 defaultrecord defaultRecord� ��� o      �� 0 parametername parameterName�  �  � l    V���� k     V�� ��� Q     ���� r    ��� c    ��� o    �� 0 thevalue theValue� m    �
� 
reco� o      �� 0 	therecord 	theRecord� R      �� 
� .ascrerr ****      � ****�    ��
� 
errn d       m      ����  � I    ��� 60 throwinvalidparametertype throwInvalidParameterType  o    �� 0 thevalue theValue  o    �� 0 parametername parameterName 	 m    

 �  r e c o r d	 � m    �
� 
reco�  �  �  r     b     o    �
�
 0 	therecord 	theRecord o    �	�	 0 defaultrecord defaultRecord o      �� 0 
fullrecord 
fullRecord  Z    7�� ?     ' n    # 1   ! #�
� 
leng o     !�� 0 
fullrecord 
fullRecord n  # & 1   $ &�
� 
leng o   # $�� 0 defaultrecord defaultRecord I   * 3�� � .0 throwinvalidparameter throwInvalidParameter  o   + ,���� 0 thevalue theValue  !  o   , -���� 0 parametername parameterName! "#" m   - .��
�� 
reco# $��$ m   . /%% �&& X c o n t a i n s   o n e   o r   m o r e   u n r e c o g n i z e d   p r o p e r t i e s��  �   �  �   '(' Z  8 S)*����) E   8 C+,+ l  8 ;-����- c   8 ;./. o   8 9���� 0 
fullrecord 
fullRecord/ m   9 :��
�� 
list��  ��  , J   ; B00 1��1 o   ; @���� 0 requiredvalue RequiredValue��  * I   F O��2���� .0 throwinvalidparameter throwInvalidParameter2 343 o   G H���� 0 thevalue theValue4 565 o   H I���� 0 parametername parameterName6 787 m   I J��
�� 
reco8 9��9 m   J K:: �;; N m i s s i n g   o n e   o r   m o r e   r e q u i r e d   p r o p e r t i e s��  ��  ��  ��  ( <��< L   T V== o   T U���� 0 
fullrecord 
fullRecord��  �D> TO DO: this should allow defaultRecord to contain a `class` property; if given, and theValue record also has a class property then error if they're different; Q. what if defaultRecord doesn't have a class property but theValue record does? (might want to append a default `class` property to defaultRecord to be sure)   � �>>|   T O   D O :   t h i s   s h o u l d   a l l o w   d e f a u l t R e c o r d   t o   c o n t a i n   a   ` c l a s s `   p r o p e r t y ;   i f   g i v e n ,   a n d   t h e V a l u e   r e c o r d   a l s o   h a s   a   c l a s s   p r o p e r t y   t h e n   e r r o r   i f   t h e y ' r e   d i f f e r e n t ;   Q .   w h a t   i f   d e f a u l t R e c o r d   d o e s n ' t   h a v e   a   c l a s s   p r o p e r t y   b u t   t h e V a l u e   r e c o r d   d o e s ?   ( m i g h t   w a n t   t o   a p p e n d   a   d e f a u l t   ` c l a s s `   p r o p e r t y   t o   d e f a u l t R e c o r d   t o   b e   s u r e )� ?@? l     ��������  ��  ��  @ ABA l     ��������  ��  ��  B CDC i  Y \EFE I      ��G���� &0 asscriptparameter asScriptParameterG HIH o      ���� 0 thevalue theValueI J��J o      ���� 0 parametername parameterName��  ��  F Q     KLMK L    NN c    OPO o    ���� 0 thevalue theValueP m    ��
�� 
scptL R      ����Q
�� .ascrerr ****      � ****��  Q ��R��
�� 
errnR d      SS m      �������  M I    ��T���� 60 throwinvalidparametertype throwInvalidParameterTypeT UVU o    ���� 0 thevalue theValueV WXW o    ���� 0 parametername parameterNameX YZY m    [[ �\\  s c r i p tZ ]��] m    ��
�� 
scpt��  ��  D ^_^ l     ��������  ��  ��  _ `a` l     ��������  ��  ��  a bcb i  ] `ded I      ��f���� "0 astypeparameter asTypeParameterf ghg o      ���� 0 thevalue theValueh i��i o      ���� 0 parametername parameterName��  ��  e Q     jklj L    mm c    non o    ���� 0 thevalue theValueo m    ��
�� 
typek R      ����p
�� .ascrerr ****      � ****��  p ��q��
�� 
errnq d      rr m      �������  l I    ��s���� 60 throwinvalidparametertype throwInvalidParameterTypes tut o    ���� 0 thevalue theValueu vwv o    ���� 0 parametername parameterNamew xyx m    zz �{{  t y p ey |��| m    ��
�� 
type��  ��  c }~} l     ��������  ��  ��  ~ � l     ��������  ��  ��  � ��� i  a d��� I      ������� ,0 asposixpathparameter asPOSIXPathParameter� ��� o      ���� 0 thevalue theValue� ���� o      ���� 0 parametername parameterName��  ��  � l    .���� Z     .������ >     ��� l    	������ I    	����
�� .corecnte****       ****� J     �� ���� o     ���� 0 thevalue theValue��  � �����
�� 
kocl� m    ��
�� 
ctxt��  ��  ��  � m   	 
����  � l   ���� L    �� o    ���� 0 thevalue theValue�jd TO DO: what if any validation should be done here? (e.g. might want to check for leading slash, and/or absence of illegal chars; would running it through NSURL help?); might be best to have separate versions of this for absolute vs relative paths (e.g. `join path` accepts either, whereas `read file` probably wants absolute path) - need to think about it   � ����   T O   D O :   w h a t   i f   a n y   v a l i d a t i o n   s h o u l d   b e   d o n e   h e r e ?   ( e . g .   m i g h t   w a n t   t o   c h e c k   f o r   l e a d i n g   s l a s h ,   a n d / o r   a b s e n c e   o f   i l l e g a l   c h a r s ;   w o u l d   r u n n i n g   i t   t h r o u g h   N S U R L   h e l p ? ) ;   m i g h t   b e   b e s t   t o   h a v e   s e p a r a t e   v e r s i o n s   o f   t h i s   f o r   a b s o l u t e   v s   r e l a t i v e   p a t h s   ( e . g .   ` j o i n   p a t h `   a c c e p t s   e i t h e r ,   w h e r e a s   ` r e a d   f i l e `   p r o b a b l y   w a n t s   a b s o l u t e   p a t h )   -   n e e d   t o   t h i n k   a b o u t   i t��  � Q    .���� L    �� n    ��� 1    ��
�� 
psxp� l   ������ c    ��� o    ���� 0 thevalue theValue� m    ��
�� 
furl��  ��  � R      �����
�� .ascrerr ****      � ****��  � �����
�� 
errn� d      �� m      �������  � I   % .������� 60 throwinvalidparametertype throwInvalidParameterType� ��� o   & '���� 0 thevalue theValue� ��� o   ' (���� 0 parametername parameterName� ��� m   ( )�� ���  P O S I X   p a t h� ���� m   ) *��
�� 
ctxt��  ��  � � � given any of AS's various file identifier objects (alias, �class furl�, etc) or a POSIX path string, returns a POSIX path string   � ���   g i v e n   a n y   o f   A S ' s   v a r i o u s   f i l e   i d e n t i f i e r   o b j e c t s   ( a l i a s ,   � c l a s s   f u r l � ,   e t c )   o r   a   P O S I X   p a t h   s t r i n g ,   r e t u r n s   a   P O S I X   p a t h   s t r i n g� ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� l     ������  � J D--------------------------------------------------------------------   � ��� � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -� ��� l     ������  � � � convenience handlers for coercing parameters to commonly-used AppleScript-ObjC types -- TO DO: add more AS-to-ASOC handlers? also include error checking, and provide both `asNSCLASS` and `asNSCLASSParameter` variants   � ����   c o n v e n i e n c e   h a n d l e r s   f o r   c o e r c i n g   p a r a m e t e r s   t o   c o m m o n l y - u s e d   A p p l e S c r i p t - O b j C   t y p e s   - -   T O   D O :   a d d   m o r e   A S - t o - A S O C   h a n d l e r s ?   a l s o   i n c l u d e   e r r o r   c h e c k i n g ,   a n d   p r o v i d e   b o t h   ` a s N S C L A S S `   a n d   ` a s N S C L A S S P a r a m e t e r `   v a r i a n t s� ��� l     ��������  ��  ��  � ��� l     ������  �  -----   � ��� 
 - - - - -� ��� l     ������  � � � NSString constructors (caution: unlike AppleScript text values, NSString does not ignore differences between composed and decomposed characters so must be explicitly normalized before searching/comparing)   � ����   N S S t r i n g   c o n s t r u c t o r s   ( c a u t i o n :   u n l i k e   A p p l e S c r i p t   t e x t   v a l u e s ,   N S S t r i n g   d o e s   n o t   i g n o r e   d i f f e r e n c e s   b e t w e e n   c o m p o s e d   a n d   d e c o m p o s e d   c h a r a c t e r s   s o   m u s t   b e   e x p l i c i t l y   n o r m a l i z e d   b e f o r e   s e a r c h i n g / c o m p a r i n g )� ��� l     ��������  ��  ��  � ��� i  e h��� I      ������� 0 
asnsstring 
asNSString� ���� o      ���� 0 thetext theText��  ��  � l    	���� L     	�� l    ������ n    ��� I    ���~� &0 stringwithstring_ stringWithString_� ��}� o    �|�| 0 thetext theText�}  �~  � n    ��� o    �{�{ 0 nsstring NSString� m     �z
�z misccura��  ��  �   parameter must be text   � ��� .   p a r a m e t e r   m u s t   b e   t e x t� ��� l     �y�x�w�y  �x  �w  � ��� l     �v�u�t�v  �u  �t  � ��� i  i l��� I      �s��r�s &0 asnsmutablestring asNSMutableString� ��q� o      �p�p 0 thetext theText�q  �r  � l    	���� L     	�� l    ��o�n� n    ��� I    �m��l�m &0 stringwithstring_ stringWithString_� ��k� o    �j�j 0 thetext theText�k  �l  � n    ��� o    �i�i "0 nsmutablestring NSMutableString� m     �h
�h misccura�o  �n  �   parameter must be text   � ��� .   p a r a m e t e r   m u s t   b e   t e x t� ��� l     �g�f�e�g  �f  �e  � ��� l     �d�c�b�d  �c  �b  � ��� i  m p��� I      �a��`�a ,0 asnormalizednsstring asNormalizedNSString�  �_  o      �^�^ 0 thetext theText�_  �`  � l     l     L      n    	 I    �]�\�[�] L0 $decomposedstringwithcanonicalmapping $decomposedStringWithCanonicalMapping�\  �[  	 l    
�Z�Y
 n     I    �X�W�X &0 stringwithstring_ stringWithString_ �V o    �U�U 0 thetext theText�V  �W   n     o    �T�T 0 nsstring NSString m     �S
�S misccura�Z  �Y  y TO DO: for matching purposes, compatibility mapping might be preferable (e.g. so "?" ligature is treated as equal to "ff"); however, that would require much more complex substitution code as it would need to convert the NSString being searched to KD but insert replacement text into the original; e.g. for general discussion, see: https://www.objc.io/issues/9-strings/unicode/    ��   T O   D O :   f o r   m a t c h i n g   p u r p o s e s ,   c o m p a t i b i l i t y   m a p p i n g   m i g h t   b e   p r e f e r a b l e   ( e . g .   s o   "�  "   l i g a t u r e   i s   t r e a t e d   a s   e q u a l   t o   " f f " ) ;   h o w e v e r ,   t h a t   w o u l d   r e q u i r e   m u c h   m o r e   c o m p l e x   s u b s t i t u t i o n   c o d e   a s   i t   w o u l d   n e e d   t o   c o n v e r t   t h e   N S S t r i n g   b e i n g   s e a r c h e d   t o   K D   b u t   i n s e r t   r e p l a c e m e n t   t e x t   i n t o   t h e   o r i g i n a l ;   e . g .   f o r   g e n e r a l   d i s c u s s i o n ,   s e e :   h t t p s : / / w w w . o b j c . i o / i s s u e s / 9 - s t r i n g s / u n i c o d e /   parameter must be text    � .   p a r a m e t e r   m u s t   b e   t e x t�  l     �R�Q�P�R  �Q  �P    l     �O�N�M�O  �N  �M    i  q t I      �L�K�L 0 
asnsobject 
asNSObject �J o      �I�I 0 thevalue theValue�J  �K   l     L        n    !"! I    �H#�G�H  0 objectatindex_ objectAtIndex_# $�F$ m    	�E�E  �F  �G  " l    %�D�C% n    &'& I    �B(�A�B $0 arraywithobject_ arrayWithObject_( )�@) o    �?�? 0 d  �@  �A  ' n    *+* o    �>�> 0 nsarray NSArray+ m     �=
�= misccura�D  �C   3 - convert any AS value to its Cocoa equivalent    �,, Z   c o n v e r t   a n y   A S   v a l u e   t o   i t s   C o c o a   e q u i v a l e n t -.- l     �<�;�:�<  �;  �:  . /0/ l     �9�8�7�9  �8  �7  0 121 l     �634�6  3  -----   4 �55 
 - - - - -2 676 l     �589�5  8 ( " parameter checking and conversion   9 �:: D   p a r a m e t e r   c h e c k i n g   a n d   c o n v e r s i o n7 ;<; l     �4�3�2�4  �3  �2  < =>= i  u x?@? I      �1A�0�1 @0 asnsregularexpressionparameter asNSRegularExpressionParameterA BCB o      �/�/ 0 thetext theTextC DED o      �.�. 0 flagoptions flagOptionsE F�-F o      �,�, 0 parametername parameterName�-  �0  @ k     >GG HIH Q     'JKLJ l   MNOM r    PQP n   RSR I    �+T�*�+ Z0 +regularexpressionwithpattern_options_error_ +regularExpressionWithPattern_options_error_T UVU I    �)W�(�) ,0 asnormalizednsstring asNormalizedNSStringW X�'X c    
YZY o    �&�& 0 thetext theTextZ m    	�%
�% 
ctxt�'  �(  V [\[ o    �$�$ 0 flagoptions flagOptions\ ]�#] l   ^�"�!^ m    � 
�  
msng�"  �!  �#  �*  S n   _`_ o    �� *0 nsregularexpression NSRegularExpression` m    �
� misccuraQ o      �� 0 asocpattern asocPatternN � � TO DO: does NSRegularExpression ever return useful error descriptions? if so, may be worth using that instead of generic error description below   O �aa"   T O   D O :   d o e s   N S R e g u l a r E x p r e s s i o n   e v e r   r e t u r n   u s e f u l   e r r o r   d e s c r i p t i o n s ?   i f   s o ,   m a y   b e   w o r t h   u s i n g   t h a t   i n s t e a d   o f   g e n e r i c   e r r o r   d e s c r i p t i o n   b e l o wK R      ��b
� .ascrerr ****      � ****�  b �c�
� 
errnc d      dd m      ����  L I    '�e�� 60 throwinvalidparametertype throwInvalidParameterTypee fgf o     �� 0 thetext theTextg hih o     !�� 0 parametername parameterNamei jkj m   ! "ll �mm  t e x tk n�n m   " #�
� 
ctxt�  �  I opo Z  ( ;qr��q =  ( +sts o   ( )�� 0 asocpattern asocPatternt m   ) *�
� 
msngr I   . 7�u�� .0 throwinvalidparameter throwInvalidParameteru vwv o   / 0�� 0 thetext theTextw xyx o   0 1�
�
 0 parametername parameterNamey z{z m   1 2�	
�	 
ctxt{ |�| m   2 3}} �~~ & n o t   a   v a l i d   p a t t e r n�  �  �  �  p � L   < >�� o   < =�� 0 asocpattern asocPattern�  > ��� l     ����  �  �  � ��� l     ��� �  �  �   � ��� i  y |��� I      ������� *0 asnslocaleparameter asNSLocaleParameter� ��� o      ���� 0 
localecode 
localeCode� ���� o      ���� 0 parametername parameterName��  ��  � k     H�� ��� l      ������  ���
		SDEF-defined commands that take a locale name should define a `for locale` parameter as follows:
		
			<parameter name="for locale" code="Loca" optional="yes" description="a locale identifier, e.g. �en_US� (default: no locale)">
				<type type="text"/>
				<type type="LclE"/>
			</parameter>
	
		The SDEF should also include the following enumeration exactly as shown:
		
			<enumeration name="LclE" code="LclE">
				<!-- important: this enum must appear exactly as-is in all SDEFs that use `for locale` parameters -->
				<enumerator name="no locale" code="LclS"/>
				<enumerator name="user locale" code="LclC"/>
			</enumeration>
		
		The `for locale` parameter should define its default value as `no locale` (unless there is a specific reason to use a different default, in which case remember to amend the parameter description accordingly). The `for locale` parameter's value should then be passed to `asNSLocaleParameter()` which will return the appropriate NSLocale instance.
	   � ���� 
 	 	 S D E F - d e f i n e d   c o m m a n d s   t h a t   t a k e   a   l o c a l e   n a m e   s h o u l d   d e f i n e   a   ` f o r   l o c a l e `   p a r a m e t e r   a s   f o l l o w s : 
 	 	 
 	 	 	 < p a r a m e t e r   n a m e = " f o r   l o c a l e "   c o d e = " L o c a "   o p t i o n a l = " y e s "   d e s c r i p t i o n = " a   l o c a l e   i d e n t i f i e r ,   e . g .    e n _ U S    ( d e f a u l t :   n o   l o c a l e ) " > 
 	 	 	 	 < t y p e   t y p e = " t e x t " / > 
 	 	 	 	 < t y p e   t y p e = " L c l E " / > 
 	 	 	 < / p a r a m e t e r > 
 	 
 	 	 T h e   S D E F   s h o u l d   a l s o   i n c l u d e   t h e   f o l l o w i n g   e n u m e r a t i o n   e x a c t l y   a s   s h o w n : 
 	 	 
 	 	 	 < e n u m e r a t i o n   n a m e = " L c l E "   c o d e = " L c l E " > 
 	 	 	 	 < ! - -   i m p o r t a n t :   t h i s   e n u m   m u s t   a p p e a r   e x a c t l y   a s - i s   i n   a l l   S D E F s   t h a t   u s e   ` f o r   l o c a l e `   p a r a m e t e r s   - - > 
 	 	 	 	 < e n u m e r a t o r   n a m e = " n o   l o c a l e "   c o d e = " L c l S " / > 
 	 	 	 	 < e n u m e r a t o r   n a m e = " u s e r   l o c a l e "   c o d e = " L c l C " / > 
 	 	 	 < / e n u m e r a t i o n > 
 	 	 
 	 	 T h e   ` f o r   l o c a l e `   p a r a m e t e r   s h o u l d   d e f i n e   i t s   d e f a u l t   v a l u e   a s   ` n o   l o c a l e `   ( u n l e s s   t h e r e   i s   a   s p e c i f i c   r e a s o n   t o   u s e   a   d i f f e r e n t   d e f a u l t ,   i n   w h i c h   c a s e   r e m e m b e r   t o   a m e n d   t h e   p a r a m e t e r   d e s c r i p t i o n   a c c o r d i n g l y ) .   T h e   ` f o r   l o c a l e `   p a r a m e t e r ' s   v a l u e   s h o u l d   t h e n   b e   p a s s e d   t o   ` a s N S L o c a l e P a r a m e t e r ( ) `   w h i c h   w i l l   r e t u r n   t h e   a p p r o p r i a t e   N S L o c a l e   i n s t a n c e . 
 	� ���� Z     H����� =    ��� o     ���� 0 
localecode 
localeCode� m    ��
�� LclELclS� L    �� n   ��� I   	 �������� 0 systemlocale systemLocale��  ��  � n   	��� o    	���� 0 nslocale NSLocale� m    ��
�� misccura� ��� =   ��� o    ���� 0 
localecode 
localeCode� m    ��
�� LclELclC� ���� L    �� n   ��� I    �������� 0 currentlocale currentLocale��  ��  � n   ��� o    ���� 0 nslocale NSLocale� m    ��
�� misccura��  � k   " H�� ��� Q   " >���� r   % *��� c   % (��� o   % &���� 0 
localecode 
localeCode� m   & '��
�� 
ctxt� o      ���� 0 
localecode 
localeCode� R      �����
�� .ascrerr ****      � ****��  � �����
�� 
errn� d      �� m      �������  � I   2 >������� 60 throwinvalidparametertype throwInvalidParameterType� ��� o   3 4���� 0 
localecode 
localeCode� ��� o   4 5���� 0 parametername parameterName� ��� m   5 6�� ��� L  n o   l o c a l e  ,    c u r r e n t   l o c a l e  ,   o r   t e x t� ���� J   6 :�� ��� m   6 7��
�� 
enum� ���� m   7 8��
�� 
ctxt��  ��  ��  � ���� l  ? H���� L   ? H�� n  ? G��� I   B G������� :0 localewithlocaleidentifier_ localeWithLocaleIdentifier_� ���� o   B C���� 0 
localecode 
localeCode��  ��  � n  ? B��� o   @ B���� 0 nslocale NSLocale� m   ? @��
�� misccura�
 TO DO: error if unrecognized code (how? +localeWithLocaleIdentifier: always returns an NSLocale instance, even if code isn't recognized; does localeIdentifier property give any clues? or is it necessary to check against NSLocale's availableLocaleIdentifiers?)   � ���   T O   D O :   e r r o r   i f   u n r e c o g n i z e d   c o d e   ( h o w ?   + l o c a l e W i t h L o c a l e I d e n t i f i e r :   a l w a y s   r e t u r n s   a n   N S L o c a l e   i n s t a n c e ,   e v e n   i f   c o d e   i s n ' t   r e c o g n i z e d ;   d o e s   l o c a l e I d e n t i f i e r   p r o p e r t y   g i v e   a n y   c l u e s ?   o r   i s   i t   n e c e s s a r y   t o   c h e c k   a g a i n s t   N S L o c a l e ' s   a v a i l a b l e L o c a l e I d e n t i f i e r s ? )��  ��  � ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� i  } ���� I      ������� $0 asnsurlparameter asNSURLParameter� ��� o      ���� 0 urltext urlText� ���� o      ���� 0 parametername parameterName��  ��  � k     '�� ��� r     ��� l    ������ n    ��� I    �������  0 urlwithstring_ URLWithString_� ���� I    
������� "0 astextparameter asTextParameter� ��� o    ���� 0 urltext urlText� ���� o    ���� 0 parametername parameterName��  ��  ��  ��  � n    ��� o    ���� 0 nsurl NSURL� m     ��
�� misccura��  ��  � o      ���� 0 asocurl asocURL� ��� l   $���� Z   $������� =   ��� o    ���� 0 asocurl asocURL� m    ��
�� 
msng� I     ������� .0 throwinvalidparameter throwInvalidParameter� ��� o    ���� 0 urltext urlText� ��� o    ���� 0 parametername parameterName� ��� m    ��
�� 
ctxt� ���� m    �� ���  n o t   a   v a l i d   U R L��  ��  ��  ��  �   NSURL requires RFC 1808   � ��� 0   N S U R L   r e q u i r e s   R F C   1 8 0 8�  ��  L   % ' o   % &���� 0 asocurl asocURL��  �  l     ��������  ��  ��    l     ��������  ��  ��    l     ��	��   J D--------------------------------------------------------------------   	 �

 � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  l     ����     type checking     �    t y p e   c h e c k i n g    l     ��������  ��  ��    i  � � I     ����
�� .Typ:NaTynull��� ��� null��   ����
�� 
Valu o      ���� 0 thevalue theValue��   k     Q  l     ����   < 6 TO DO: do any other types require special-case tests?    � l   T O   D O :   d o   a n y   o t h e r   t y p e s   r e q u i r e   s p e c i a l - c a s e   t e s t s ? �� Z     Q !" >     #$# l    	%����% I    	��&'
�� .corecnte****       ****& J     (( )��) o     ���� 0 thevalue theValue��  ' ��*��
�� 
kocl* m    ��
�� 
obj ��  ��  ��  $ m   	 
����    l   +,-+ L    .. m    ��
�� 
obj , #  avoid implicit dereferencing   - �// :   a v o i d   i m p l i c i t   d e r e f e r e n c i n g! 010 >    232 l   4����4 I   ��56
�� .corecnte****       ****5 J    77 8��8 o    ���� 0 thevalue theValue��  6 ��9��
�� 
kocl9 m    ��
�� 
capp��  ��  ��  3 m    ����  1 :;: l  ! #<=>< L   ! #?? m   ! "��
�� 
capp= � { avoid implicit dereferencing (we don't want `application NAME` value being treated as an object specifier root, i.e. null)   > �@@ �   a v o i d   i m p l i c i t   d e r e f e r e n c i n g   ( w e   d o n ' t   w a n t   ` a p p l i c a t i o n   N A M E `   v a l u e   b e i n g   t r e a t e d   a s   a n   o b j e c t   s p e c i f i e r   r o o t ,   i . e .   n u l l ); ABA >   & 1CDC l  & /E����E I  & /��FG
�� .corecnte****       ****F J   & )HH I��I o   & '���� 0 thevalue theValue��  G ��J��
�� 
koclJ m   * +��
�� 
reco��  ��  ��  D m   / 0����  B KLK l  4 6MNOM L   4 6PP m   4 5�
� 
recoN %  ignore custom `class` property   O �QQ >   i g n o r e   c u s t o m   ` c l a s s `   p r o p e r t yL RSR >   9 DTUT l  9 BV�~�}V I  9 B�|WX
�| .corecnte****       ****W J   9 <YY Z�{Z o   9 :�z�z 0 thevalue theValue�{  X �y[�x
�y 
kocl[ m   = >�w
�w 
scpt�x  �~  �}  U m   B C�v�v  S \�u\ l  G I]^_] L   G I`` m   G H�t
�t 
scpt^ %  ignore custom `class` property   _ �aa >   i g n o r e   c u s t o m   ` c l a s s `   p r o p e r t y�u  " L   L Qbb n   L Pcdc m   M O�s
�s 
pclsd o   L M�r�r 0 thevalue theValue��   efe l     �q�p�o�q  �p  �o  f ghg l     �n�m�l�n  �m  �l  h iji i  � �klk I     �k�jm
�k .Typ:ChkTnull��� ��� null�j  m �ino
�i 
Valun o      �h�h 0 thevalue theValueo �gp�f
�g 
Typep o      �e�e 0 typeclasses typeClasses�f  l l   1qrsq k    1tt uvu l      �dwx�d  w��
		Important: while using a `theValue's class is typeClass` test might seem the simpler solution, it isn't reliable in practice: record and script objects can define arbitrary `class` properties; reference objects are implicitly de-referenced to the class of the referenced object instead, while application objects dereference to `null`; `class of 3 is number` always returns false, and so on. A somewhat more reliable approach takes advantage of AppleScript's query-style filtering, e.g. `every number of {3}` returns `{3}` whereas `every number of {"3"}` returns `{}`, although this doesn't work correctly across all types (e.g. `type class`, `constant`). This handler implements special-case tests for the problem cases, then uses `(count {theValue} each typeClass) � 0` to check for the rest, which is functionally equivalent to `every TYPE of {VALUE} � {}` but with the advantage that it can be parameterized with an arbitrary type class value, avoiding the need to hardcode every single query.
		
		-- TO DO: move following to TypeSupport.unittest.scpt as asserts
		
		log (check type for 3 is integer) -- true
		log (check type for 3 is real) -- false
		log (check type for 3 is number) -- true
		
		script scpt
			property class : document
		end script
		log (check type for scpt is document) -- false
		log (check type for scpt is script) -- true
		
		log (check type for document is class) -- true
		log (check type for document is type class) -- true
	   x �yyp 
 	 	 I m p o r t a n t :   w h i l e   u s i n g   a   ` t h e V a l u e ' s   c l a s s   i s   t y p e C l a s s `   t e s t   m i g h t   s e e m   t h e   s i m p l e r   s o l u t i o n ,   i t   i s n ' t   r e l i a b l e   i n   p r a c t i c e :   r e c o r d   a n d   s c r i p t   o b j e c t s   c a n   d e f i n e   a r b i t r a r y   ` c l a s s `   p r o p e r t i e s ;   r e f e r e n c e   o b j e c t s   a r e   i m p l i c i t l y   d e - r e f e r e n c e d   t o   t h e   c l a s s   o f   t h e   r e f e r e n c e d   o b j e c t   i n s t e a d ,   w h i l e   a p p l i c a t i o n   o b j e c t s   d e r e f e r e n c e   t o   ` n u l l ` ;   ` c l a s s   o f   3   i s   n u m b e r `   a l w a y s   r e t u r n s   f a l s e ,   a n d   s o   o n .   A   s o m e w h a t   m o r e   r e l i a b l e   a p p r o a c h   t a k e s   a d v a n t a g e   o f   A p p l e S c r i p t ' s   q u e r y - s t y l e   f i l t e r i n g ,   e . g .   ` e v e r y   n u m b e r   o f   { 3 } `   r e t u r n s   ` { 3 } `   w h e r e a s   ` e v e r y   n u m b e r   o f   { " 3 " } `   r e t u r n s   ` { } ` ,   a l t h o u g h   t h i s   d o e s n ' t   w o r k   c o r r e c t l y   a c r o s s   a l l   t y p e s   ( e . g .   ` t y p e   c l a s s ` ,   ` c o n s t a n t ` ) .   T h i s   h a n d l e r   i m p l e m e n t s   s p e c i a l - c a s e   t e s t s   f o r   t h e   p r o b l e m   c a s e s ,   t h e n   u s e s   ` ( c o u n t   { t h e V a l u e }   e a c h   t y p e C l a s s )  "`   0 `   t o   c h e c k   f o r   t h e   r e s t ,   w h i c h   i s   f u n c t i o n a l l y   e q u i v a l e n t   t o   ` e v e r y   T Y P E   o f   { V A L U E }  "`   { } `   b u t   w i t h   t h e   a d v a n t a g e   t h a t   i t   c a n   b e   p a r a m e t e r i z e d   w i t h   a n   a r b i t r a r y   t y p e   c l a s s   v a l u e ,   a v o i d i n g   t h e   n e e d   t o   h a r d c o d e   e v e r y   s i n g l e   q u e r y . 
 	 	 
 	 	 - -   T O   D O :   m o v e   f o l l o w i n g   t o   T y p e S u p p o r t . u n i t t e s t . s c p t   a s   a s s e r t s 
 	 	 
 	 	 l o g   ( c h e c k   t y p e   f o r   3   i s   i n t e g e r )   - -   t r u e 
 	 	 l o g   ( c h e c k   t y p e   f o r   3   i s   r e a l )   - -   f a l s e 
 	 	 l o g   ( c h e c k   t y p e   f o r   3   i s   n u m b e r )   - -   t r u e 
 	 	 
 	 	 s c r i p t   s c p t 
 	 	 	 p r o p e r t y   c l a s s   :   d o c u m e n t 
 	 	 e n d   s c r i p t 
 	 	 l o g   ( c h e c k   t y p e   f o r   s c p t   i s   d o c u m e n t )   - -   f a l s e 
 	 	 l o g   ( c h e c k   t y p e   f o r   s c p t   i s   s c r i p t )   - -   t r u e 
 	 	 
 	 	 l o g   ( c h e c k   t y p e   f o r   d o c u m e n t   i s   c l a s s )   - -   t r u e 
 	 	 l o g   ( c h e c k   t y p e   f o r   d o c u m e n t   i s   t y p e   c l a s s )   - -   t r u e 
 	v z�cz Q    1{|}{ k   ~~ � Z   ���b�a� =    ��� l   ��`�_� I   �^��
�^ .corecnte****       ****� J    �� ��]� o    �\�\ 0 typeclasses typeClasses�]  � �[��Z
�[ 
kocl� m    �Y
�Y 
list�Z  �`  �_  � m    �X�X  � r    ��� J    �� ��W� o    �V�V 0 typeclasses typeClasses�W  � o      �U�U 0 typeclasses typeClasses�b  �a  � ��� X   ��T�� k   +�� ��� Q   + I���� r   . 5��� c   . 3��� n   . 1��� 1   / 1�S
�S 
pcnt� o   . /�R�R 0 aref aRef� m   1 2�Q
�Q 
pcls� o      �P�P 0 	typeclass 	typeClass� R      �O�N�
�O .ascrerr ****      � ****�N  � �M��L
�M 
errn� d      �� m      �K�K��L  � l  = I���� R   = I�J��I
�J .ascrerr ****      � ****� n  ? H��� I   @ H�H��G�H 60 throwinvalidparametertype throwInvalidParameterType� ��� o   @ A�F�F 0 	typeclass 	typeClass� ��� m   A B�� ���  i s   t y p e� ��� m   B C�� ��� @ t y p e   c l a s s   o r   l i s t   o f   t y p e   c l a s s� ��E� m   C D�D
�D 
pcls�E  �G  � o   ? @�C�C 0 _support  �I  � * $ TO DO: move to asTypeClassParameter   � ��� H   T O   D O :   m o v e   t o   a s T y p e C l a s s P a r a m e t e r� ��� l  J J�B���B  � � � note: `count {theValue} each class/constant` doesn't work when theValue is a type class/constant symbol (e.g. `integer`/`yes`), so these need to be explicitly checked -- TO DO: are there any other AS type classes that also need special handling   � ����   n o t e :   ` c o u n t   { t h e V a l u e }   e a c h   c l a s s / c o n s t a n t `   d o e s n ' t   w o r k   w h e n   t h e V a l u e   i s   a   t y p e   c l a s s / c o n s t a n t   s y m b o l   ( e . g .   ` i n t e g e r ` / ` y e s ` ) ,   s o   t h e s e   n e e d   t o   b e   e x p l i c i t l y   c h e c k e d   - -   T O   D O :   a r e   t h e r e   a n y   o t h e r   A S   t y p e   c l a s s e s   t h a t   a l s o   n e e d   s p e c i a l   h a n d l i n g� ��A� Z   J����@� G   J U��� =  J M��� o   J K�?�? 0 	typeclass 	typeClass� m   K L�>
�> 
pcls� =  P S��� o   P Q�=�= 0 	typeclass 	typeClass� m   Q R�<
�< 
type� l  X ����� k   X ��� ��� l  X X�;���;  � � � check value is not a reference type (be aware that library's SDEF terminology reformats `reference` keyword as `specifier`), then try coercing it to type class, and finally check it's unchanged -- TO DO: check this covers all corner cases   � ����   c h e c k   v a l u e   i s   n o t   a   r e f e r e n c e   t y p e   ( b e   a w a r e   t h a t   l i b r a r y ' s   S D E F   t e r m i n o l o g y   r e f o r m a t s   ` r e f e r e n c e `   k e y w o r d   a s   ` s p e c i f i e r ` ) ,   t h e n   t r y   c o e r c i n g   i t   t o   t y p e   c l a s s ,   a n d   f i n a l l y   c h e c k   i t ' s   u n c h a n g e d   - -   T O   D O :   c h e c k   t h i s   c o v e r s   a l l   c o r n e r   c a s e s� ��:� Q   X ����9� Z  [ y���8�7� F   [ p��� =   [ f��� l  [ d��6�5� I  [ d�4��
�4 .corecnte****       ****� J   [ ^�� ��3� o   [ \�2�2 0 thevalue theValue�3  � �1��0
�1 
kocl� m   _ `�/
�/ 
obj �0  �6  �5  � m   d e�.�.  � =  i n��� c   i l��� l 	 i j��-�,� o   i j�+�+ 0 thevalue theValue�-  �,  � m   j k�*
�* 
pcls� o   l m�)�) 0 thevalue theValue� L   s u�� m   s t�(
�( boovtrue�8  �7  � R      �'�&�
�' .ascrerr ****      � ****�&  � �%��$
�% 
errn� d      �� m      �#�#��$  �9  �:  �'! TO DO: this could be problematic (AS is murky on distinction between `class` and `type class`, treating them as synonymous when used in `as` operation but not when comparing them; be aware that library's SDEF causes `type class` keyword to reformat as `type` keyword (for added confusion)   � ���B   T O   D O :   t h i s   c o u l d   b e   p r o b l e m a t i c   ( A S   i s   m u r k y   o n   d i s t i n c t i o n   b e t w e e n   ` c l a s s `   a n d   ` t y p e   c l a s s ` ,   t r e a t i n g   t h e m   a s   s y n o n y m o u s   w h e n   u s e d   i n   ` a s `   o p e r a t i o n   b u t   n o t   w h e n   c o m p a r i n g   t h e m ;   b e   a w a r e   t h a t   l i b r a r y ' s   S D E F   c a u s e s   ` t y p e   c l a s s `   k e y w o r d   t o   r e f o r m a t   a s   ` t y p e `   k e y w o r d   ( f o r   a d d e d   c o n f u s i o n )� ��� =  � ���� o   � ��"�" 0 	typeclass 	typeClass� m   � ��!
�! 
enum� ��� Q   � ���� � Z  � ������ F   � ���� =   � ���� l  � ����� I  � ����
� .corecnte****       ****� J   � ��� ��� o   � ��� 0 thevalue theValue�  � ���
� 
kocl� m   � ��
� 
obj �  �  �  � m   � ���  � =  � ���� c   � ���� l 	 � ����� o   � ��� 0 thevalue theValue�  �  � m   � ��
� 
enum� o   � ��� 0 thevalue theValue� L   � ��� m   � ��
� boovtrue�  �  � R      �� 
� .ascrerr ****      � ****�    ��
� 
errn d       m      �
�
��  �   �  =  � � o   � ��	�	 0 typeclasses typeClasses m   � ��
� 
ocid  l  � �	
	 k   � �  Z  � ��� =   � � l  � ��� I  � ��
� .corecnte****       **** J   � � � o   � ��� 0 thevalue theValue�   � ��
�  
kocl m   � ���
�� 
obj ��  �  �   m   � �����   L   � � m   � ���
�� boovfals�  �   �� l  � � L   � � =  � �  n  � �!"! m   � ���
�� 
want" l  � �#����# c   � �$%$ o   � ����� 0 thevalue theValue% m   � ���
�� 
reco��  ��    m   � ���
�� 
ocid � � check object specifier record's `want` property; hacky, but should be okay as long as AS's specifier-to-record coercion never changes    �&&   c h e c k   o b j e c t   s p e c i f i e r   r e c o r d ' s   ` w a n t `   p r o p e r t y ;   h a c k y ,   b u t   s h o u l d   b e   o k a y   a s   l o n g   a s   A S ' s   s p e c i f i e r - t o - r e c o r d   c o e r c i o n   n e v e r   c h a n g e s��  
 * $ is it an AppleScriptObjC specifier?    �'' H   i s   i t   a n   A p p l e S c r i p t O b j C   s p e c i f i e r ? ()( >   � �*+* l  � �,����, I  � ���-.
�� .corecnte****       ****- J   � �// 0��0 o   � ����� 0 thevalue theValue��  . ��1��
�� 
kocl1 m   � ���
�� 
capp��  ��  ��  + m   � �����  ) 232 L   � �44 =  � �565 o   � ����� 0 	typeclass 	typeClass6 m   � ���
�� 
capp3 787 >   �
9:9 l  �;����; I  ���<=
�� .corecnte****       ****< J   �>> ?��? o   � ���� 0 thevalue theValue��  = ��@��
�� 
kocl@ o  ���� 0 	typeclass 	typeClass��  ��  ��  : m  	����  8 A��A l BCDB L  EE m  ��
�� boovtrueC y s other AS types can be reliably filtered using a `count` command -- TO DO: need to confirm this works for all types   D �FF �   o t h e r   A S   t y p e s   c a n   b e   r e l i a b l y   f i l t e r e d   u s i n g   a   ` c o u n t `   c o m m a n d   - -   T O   D O :   n e e d   t o   c o n f i r m   t h i s   w o r k s   f o r   a l l   t y p e s��  �@  �A  �T 0 aref aRef� o    ���� 0 typeclasses typeClasses� G��G L  HH m  ��
�� boovfals��  | R      ��IJ
�� .ascrerr ****      � ****I o      ���� 0 etext eTextJ ��KL
�� 
errnK o      ���� 0 enumber eNumberL ��MN
�� 
erobM o      ���� 0 efrom eFromN ��O��
�� 
errtO o      ���� 
0 eto eTo��  } I  #1��P���� 
0 _error  P QRQ m  $'SS �TT  c h e c k   t y p eR UVU o  '(���� 0 etext eTextV WXW o  ()���� 0 enumber eNumberX YZY o  )*���� 0 efrom eFromZ [��[ o  *+���� 
0 eto eTo��  ��  �c  r �  performs a 'VALUE is-a CLASS' test, which is trickier than it sounds since AppleScript has neither classes nor `is-a` operator   s �\\ �   p e r f o r m s   a   ' V A L U E   i s - a   C L A S S '   t e s t ,   w h i c h   i s   t r i c k i e r   t h a n   i t   s o u n d s   s i n c e   A p p l e S c r i p t   h a s   n e i t h e r   c l a s s e s   n o r   ` i s - a `   o p e r a t o rj ]^] l     ��������  ��  ��  ^ _`_ l     ��������  ��  ��  ` aba i  � �cdc I     ����e
�� .Typ:OCIDnull��� ��� null��  e ��f��
�� 
Fromf o      ���� 0 thevalue theValue��  d l    #ghig Q     #jklj L    mm n   non I    ��p����  0 objectatindex_ objectAtIndex_p q��q m    ����  ��  ��  o l   r����r n   sts I    ��u���� $0 arraywithobject_ arrayWithObject_u v��v o    ���� 0 d  ��  ��  t n   wxw o    ���� 0 nsarray NSArrayx m    ��
�� misccura��  ��  k R      ��yz
�� .ascrerr ****      � ****y o      ���� 0 etext eTextz ��{|
�� 
errn{ o      ���� 0 enumber eNumber| ��}~
�� 
erob} o      ���� 0 efrom eFrom~ ����
�� 
errt o      ���� 
0 eto eTo��  l I    #������� 
0 _error  � ��� m    �� ���   c o n v e r t   t o   C o c o a� ��� o    ���� 0 etext eText� ��� o    ���� 0 enumber eNumber� ��� o    ���� 0 efrom eFrom� ���� o    ���� 
0 eto eTo��  ��  h 3 - TO DO: asNSObject() performs same conversion   i ��� Z   T O   D O :   a s N S O b j e c t ( )   p e r f o r m s   s a m e   c o n v e r s i o nb ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ���� l     ��������  ��  ��  ��       !������������������������������������  � ������������������������������������������������������~�}�|�{
�� 
pimr�� 0 
hashandler 
hasHandler�� .0 throwinvalidparameter throwInvalidParameter�� 60 throwinvalidparametertype throwInvalidParameterType�� >0 throwinvalidparameterconstant throwInvalidParameterConstant�� 0 rethrowerror rethrowError�� &0 throwcommanderror throwCommandError�� $0 throwmethoderror throwMethodError�� (0 asbooleanparameter asBooleanParameter�� (0 asintegerparameter asIntegerParameter�� "0 asrealparameter asRealParameter�� &0 asnumberparameter asNumberParameter�� "0 astextparameter asTextParameter�� "0 asdateparameter asDateParameter�� "0 aslistparameter asListParameter�� &0 asrecordparameter asRecordParameter�� 0 requiredvalue RequiredValue�� 60 asoptionalrecordparameter asOptionalRecordParameter�� &0 asscriptparameter asScriptParameter�� "0 astypeparameter asTypeParameter�� ,0 asposixpathparameter asPOSIXPathParameter�� 0 
asnsstring 
asNSString�� &0 asnsmutablestring asNSMutableString�� ,0 asnormalizednsstring asNormalizedNSString�� 0 
asnsobject 
asNSObject�� @0 asnsregularexpressionparameter asNSRegularExpressionParameter� *0 asnslocaleparameter asNSLocaleParameter�~ $0 asnsurlparameter asNSURLParameter
�} .Typ:NaTynull��� ��� null
�| .Typ:ChkTnull��� ��� null
�{ .Typ:OCIDnull��� ��� null� �z��z �  �� �y��x
�y 
cobj� ��   �w 
�w 
frmk�x  � �v 8�u�t���s�v 0 
hashandler 
hasHandler�u �r��r �  �q�q 0 
handlerref 
handlerRef�t  � �p�p 0 
handlerref 
handlerRef� �o�n�
�o 
hand�n  � �m�l�k
�m 
errn�l�\�k  �s  ��&OeW 	X  f� �j l�i�h���g�j .0 throwinvalidparameter throwInvalidParameter�i �f��f �  �e�d�c�b�e 0 thevalue theValue�d 0 parametername parameterName�c 0 expectedtype expectedType�b $0 errordescription errorDescription�h  � �a�`�_�^�a 0 thevalue theValue�` 0 parametername parameterName�_ 0 expectedtype expectedType�^ $0 errordescription errorDescription� �] � � ��\�[�Z�Y�X�W � � �
�] 
leng
�\ 
errn�[�Y
�Z 
erob
�Y 
errt
�X 
enum�W �g )��,j  �E�Y 	�%�%E�O)�������%�%�%�%� �V ��U�T���S�V 60 throwinvalidparametertype throwInvalidParameterType�U �R��R �  �Q�P�O�N�Q 0 thevalue theValue�P 0 parametername parameterName�O $0 expectedtypename expectedTypeName�N 0 expectedtype expectedType�T  � �M�L�K�J�I�M 0 thevalue theValue�L 0 parametername parameterName�K $0 expectedtypename expectedTypeName�J 0 expectedtype expectedType�I  0 actualtypename actualTypeName� �H�G�F � ��E�D�C � ��B�A
�H 
kocl
�G 
obj 
�F .corecnte****       ****
�E 
pcls�D  �C  �B �A .0 throwinvalidparameter throwInvalidParameter�S 8  �kv��l j �E�Y 	��,%E�W 
X  �E�O*����%�%�+ � �@ ��?�>���=�@ >0 throwinvalidparameterconstant throwInvalidParameterConstant�? �<��< �  �;�:�; 0 thevalue theValue�: 0 parametername parameterName�>  � �9�8�9 0 thevalue theValue�8 0 parametername parameterName� �7 ��6�5
�7 
enum�6 �5 .0 throwinvalidparameter throwInvalidParameter�= 
*�����+ � �4�3�2���1�4 0 rethrowerror rethrowError�3 �0��0 �  �/�.�-�,�+�*�)�(�/ 0 libraryname libraryName�. 0 handlername handlerName�- 0 etext eText�, 0 enumber eNumber�+ 0 efrom eFrom�* 
0 eto eTo�) $0 targetobjectname targetObjectName�( 0 partialresult partialResult�2  � �'�&�%�$�#�"�!� �' 0 libraryname libraryName�& 0 handlername handlerName�% 0 etext eText�$ 0 enumber eNumber�# 0 efrom eFrom�" 
0 eto eTo�! $0 targetobjectname targetObjectName�  0 partialresult partialResult� 
13�A������
� 
msng
� 
errn
� 
erob
� 
errt� 
� 
ptlr� �1 >��%�%�%�%E�O�� ��%�%E�Y hO��  )����Y )������ �h������ &0 throwcommanderror throwCommandError� ��� �  ������� 0 libraryname libraryName� 0 handlername handlerName� 0 etext eText� 0 enumber eNumber� 0 efrom eFrom� 
0 eto eTo�  � ����
�	�� 0 libraryname libraryName� 0 handlername handlerName� 0 etext eText�
 0 enumber eNumber�	 0 efrom eFrom� 
0 eto eTo� ���
� 
msng� � 0 rethrowerror rethrowError� )j*���������+ � �������� $0 throwmethoderror throwMethodError� � ��  �  ���������������� 0 libraryname libraryName�� $0 targetobjectname targetObjectName�� 0 handlername handlerName�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo�  � ���������������� 0 libraryname libraryName�� $0 targetobjectname targetObjectName�� 0 handlername handlerName�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo� ������
�� 
msng�� �� 0 rethrowerror rethrowError� )j*���������+ � ������������� (0 asbooleanparameter asBooleanParameter�� ����� �  ������ 0 thevalue theValue�� 0 parametername parameterName��  � ������ 0 thevalue theValue�� 0 parametername parameterName� ����������
�� 
bool��  � ������
�� 
errn���\��  �� �� 60 throwinvalidparametertype throwInvalidParameterType��  	��&W X  *�����+ � ������������� (0 asintegerparameter asIntegerParameter�� ����� �  ������ 0 thevalue theValue�� 0 parametername parameterName��  � ������ 0 thevalue theValue�� 0 parametername parameterName� ����������
�� 
long��  � ������
�� 
errn���\��  �� �� 60 throwinvalidparametertype throwInvalidParameterType��  	��&W X  *�����+ � ��	���������� "0 asrealparameter asRealParameter�� ����� �  ������ 0 thevalue theValue�� 0 parametername parameterName��  � ������ 0 thevalue theValue�� 0 parametername parameterName� ���������
�� 
doub��  � ������
�� 
errn���\��  �� �� 60 throwinvalidparametertype throwInvalidParameterType��  	��&W X  *�����+ � ��(���������� &0 asnumberparameter asNumberParameter�� ����� �  ������ 0 thevalue theValue�� 0 parametername parameterName��  � ������ 0 thevalue theValue�� 0 parametername parameterName� �����=����
�� 
nmbr��  � ������
�� 
errn���\��  �� �� 60 throwinvalidparametertype throwInvalidParameterType��  	��&W X  *�����+ � ��G���������� "0 astextparameter asTextParameter�� ����� �  ������ 0 thevalue theValue�� 0 parametername parameterName��  � ������ 0 thevalue theValue�� 0 parametername parameterName� �����_����
�� 
ctxt��  � ������
�� 
errn���\��  �� �� 60 throwinvalidparametertype throwInvalidParameterType��  	��&W X  *�����+ � ��j���������� "0 asdateparameter asDateParameter�� ����� �  ������ 0 thevalue theValue�� 0 parametername parameterName��  � ������ 0 thevalue theValue�� 0 parametername parameterName� ����������
�� 
ldt ��  � ������
�� 
errn���\��  �� �� 60 throwinvalidparametertype throwInvalidParameterType��  	��&W X  *�����+ � ������������� "0 aslistparameter asListParameter�� ����� �  ���� 0 thevalue theValue��  � ���� 0 thevalue theValue� ������
�� 
kocl
�� 
list
�� .corecnte****       ****�� �kv��l j  	�kvY �� ������������� &0 asrecordparameter asRecordParameter�� ����� �  ��~� 0 thevalue theValue�~ 0 parametername parameterName��  � �}�|�} 0 thevalue theValue�| 0 parametername parameterName� �{�z���y�x
�{ 
reco�z  � �w�v�u
�w 
errn�v�\�u  �y �x 60 throwinvalidparametertype throwInvalidParameterType��  	��&W X  *�����+ � �t�  ��t 0 requiredvalue RequiredValue�  ��  � �s��r�q���p�s 60 asoptionalrecordparameter asOptionalRecordParameter�r �o��o �  �n�m�l�n 0 thevalue theValue�m 0 defaultrecord defaultRecord�l 0 parametername parameterName�q  � �k�j�i�h�g�k 0 thevalue theValue�j 0 defaultrecord defaultRecord�i 0 parametername parameterName�h 0 	therecord 	theRecord�g 0 
fullrecord 
fullRecord� �f�e�
�d�c�b%�a�`:
�f 
reco�e  � �_�^�]
�_ 
errn�^�\�]  �d �c 60 throwinvalidparametertype throwInvalidParameterType
�b 
leng�a .0 throwinvalidparameter throwInvalidParameter
�` 
list�p W 
��&E�W X  *�����+ O��%E�O��,��, *�����+ Y hO��&b  kv *�����+ Y hO�� �\F�[�Z���Y�\ &0 asscriptparameter asScriptParameter�[ �X��X �  �W�V�W 0 thevalue theValue�V 0 parametername parameterName�Z  � �U�T�U 0 thevalue theValue�T 0 parametername parameterName� �S�R�[�Q�P
�S 
scpt�R  � �O�N�M
�O 
errn�N�\�M  �Q �P 60 throwinvalidparametertype throwInvalidParameterType�Y  	��&W X  *�����+ � �Le�K�J���I�L "0 astypeparameter asTypeParameter�K �H��H �  �G�F�G 0 thevalue theValue�F 0 parametername parameterName�J  � �E�D�E 0 thevalue theValue�D 0 parametername parameterName� �C�B�z�A�@
�C 
type�B  � �?�>�=
�? 
errn�>�\�=  �A �@ 60 throwinvalidparametertype throwInvalidParameterType�I  	��&W X  *�����+ � �<��;�:���9�< ,0 asposixpathparameter asPOSIXPathParameter�; �8��8 �  �7�6�7 0 thevalue theValue�6 0 parametername parameterName�:  � �5�4�5 0 thevalue theValue�4 0 parametername parameterName� 
�3�2�1�0�/�.���-�,
�3 
kocl
�2 
ctxt
�1 .corecnte****       ****
�0 
furl
�/ 
psxp�.  � �+�*�)
�+ 
errn�*�\�)  �- �, 60 throwinvalidparametertype throwInvalidParameterType�9 /�kv��l j �Y  ��&�,EW X  *�����+ 	� �(��'�&���%�( 0 
asnsstring 
asNSString�' �$��$ �  �#�# 0 thetext theText�&  � �"�" 0 thetext theText� �!� �
�! misccura�  0 nsstring NSString� &0 stringwithstring_ stringWithString_�% 
��,�k+ � ���� �� &0 asnsmutablestring asNSMutableString� ��   �� 0 thetext theText�    �� 0 thetext theText ���
� misccura� "0 nsmutablestring NSMutableString� &0 stringwithstring_ stringWithString_� 
��,�k+ � ������ ,0 asnormalizednsstring asNormalizedNSString� ��   �� 0 thetext theText�   �� 0 thetext theText ����

� misccura� 0 nsstring NSString� &0 stringwithstring_ stringWithString_�
 L0 $decomposedstringwithcanonicalmapping $decomposedStringWithCanonicalMapping� ��,�k+ j+ � �	����	 0 
asnsobject 
asNSObject� ��   �� 0 thevalue theValue�   ��� 0 thevalue theValue� 0 d   �� ����
� misccura�  0 nsarray NSArray�� $0 arraywithobject_ arrayWithObject_��  0 objectatindex_ objectAtIndex_� ��,�k+ jk+ � ��@����	
���� @0 asnsregularexpressionparameter asNSRegularExpressionParameter�� ����   �������� 0 thetext theText�� 0 flagoptions flagOptions�� 0 parametername parameterName��  	 ���������� 0 thetext theText�� 0 flagoptions flagOptions�� 0 parametername parameterName�� 0 asocpattern asocPattern
 ��������������l����}��
�� misccura�� *0 nsregularexpression NSRegularExpression
�� 
ctxt�� ,0 asnormalizednsstring asNormalizedNSString
�� 
msng�� Z0 +regularexpressionwithpattern_options_error_ +regularExpressionWithPattern_options_error_��   ������
�� 
errn���\��  �� �� 60 throwinvalidparametertype throwInvalidParameterType�� .0 throwinvalidparameter throwInvalidParameter�� ? ��,*��&k+ ��m+ E�W X  *�����+ 
O��  *�����+ Y hO�� ����������� *0 asnslocaleparameter asNSLocaleParameter�� ����   ������ 0 
localecode 
localeCode�� 0 parametername parameterName��   ������ 0 
localecode 
localeCode�� 0 parametername parameterName �������������������������
�� LclELclS
�� misccura�� 0 nslocale NSLocale�� 0 systemlocale systemLocale
�� LclELclC�� 0 currentlocale currentLocale
�� 
ctxt��   ������
�� 
errn���\��  
�� 
enum�� �� 60 throwinvalidparametertype throwInvalidParameterType�� :0 localewithlocaleidentifier_ localeWithLocaleIdentifier_�� I��  ��,j+ Y 9��  ��,j+ Y ( 
��&E�W X  *�����lv�+ O��,�k+ � ����������� $0 asnsurlparameter asNSURLParameter�� ����   ������ 0 urltext urlText�� 0 parametername parameterName��   �������� 0 urltext urlText�� 0 parametername parameterName�� 0 asocurl asocURL 	�����������������
�� misccura�� 0 nsurl NSURL�� "0 astextparameter asTextParameter��  0 urlwithstring_ URLWithString_
�� 
msng
�� 
ctxt�� �� .0 throwinvalidparameter throwInvalidParameter�� (��,*��l+ k+ E�O��  *�����+ Y hO�� ��������
�� .Typ:NaTynull��� ��� null��  �� ������
�� 
Valu�� 0 thevalue theValue��   ���� 0 thevalue theValue ��������������
�� 
kocl
�� 
obj 
�� .corecnte****       ****
�� 
capp
�� 
reco
�� 
scpt
�� 
pcls�� R�kv��l j �Y @�kv��l j �Y -�kv��l j �Y �kv��l j �Y ��,E� ��l������
�� .Typ:ChkTnull��� ��� null��  �� ����
�� 
Valu�� 0 thevalue theValue ������
�� 
Type�� 0 typeclasses typeClasses��   	�������������������� 0 thevalue theValue�� 0 typeclasses typeClasses�� 0 aref aRef�� 0 	typeclass 	typeClass�� 0 _support  �� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo ��������������������������������������S����
�� 
kocl
�� 
list
�� .corecnte****       ****
�� 
cobj
�� 
pcnt
�� 
pcls��   ������
�� 
errn���\��  �� �� 60 throwinvalidparametertype throwInvalidParameterType
�� 
type
�� 
bool
�� 
obj 
�� 
enum
�� 
ocid
�� 
reco
�� 
want
�� 
capp�� 0 etext eText ����
�� 
errn�� 0 enumber eNumber ���
�� 
erob� 0 efrom eFrom �~�}�|
�~ 
errt�} 
0 eto eTo�|  �� �� 
0 _error  ��2�kv��l j  
�kvE�Y hO ��[��l kh  ��,�&E�W X  )j������+ O�� 
 �� �& / #�kv��l j 	 	��&� �& eY hW X  hY ���  / #�kv��l j 	 	��&� �& eY hW X  hY ]�a   (�kv��l j  fY hO�a &a ,a  Y /�kv�a l j �a  Y �kv�l j eY h[OY�OfW X  *a ����a + � �{d�z�y�x
�{ .Typ:OCIDnull��� ��� null�z  �y �w�v�u
�w 
From�v 0 thevalue theValue�u   �t�s�r�q�p�o�t 0 thevalue theValue�s 0 d  �r 0 etext eText�q 0 enumber eNumber�p 0 efrom eFrom�o 
0 eto eTo 	�n�m�l�k�j��i�h
�n misccura�m 0 nsarray NSArray�l $0 arraywithobject_ arrayWithObject_�k  0 objectatindex_ objectAtIndex_�j 0 etext eText �g�f 
�g 
errn�f 0 enumber eNumber  �e�d!
�e 
erob�d 0 efrom eFrom! �c�b�a
�c 
errt�b 
0 eto eTo�a  �i �h 
0 _error  �x $ ��,�k+ jk+ W X  *梣���+ ascr  ��ޭ