FasdUAS 1.101.10   ��   ��    k             l      ��  ��   
-
' Date -- make, parse, and format dates and date strings

Caution:

- AppleScript's date objects are mutable(!), so any time a new date object is needed, either construct it from scratch using ASOC's `(NSDate's date...()) as date`, Standard Additions' `current date` command, or `copy _defaultDate to newDate` and work on the *copy*. NEVER use, modify, or return _defaultDate (or any other retained date object) directly, as allowing a shared mutable object to escape from this library and run loose around users' programs is a guaranteed recipe for chaos and disaster. (It's bad enough when lists and records do this, but dates don't look like mutable collections so users are even less likely to realize they contain shareable state.)

TO DO: 

- should `join date` implement optional `with/without rollover allowed` parameter to determine if out-of-range values should be allowed to rollover or not (default: error if rollover detected) check for any out-of-range properties, as AS will silently roll over (Q. what about leap-seconds?) TBH, probably be simpler and safer to range-check year+month+hours+minutes (all those ranges are fixed, so as long as the rec's properties are anywhere within those ranges they're ok), and comparison-check the day (allowing some flexibility in the event that a leap second nudges it over to the next day), and finally check the seconds isn't obviously invalid (e.g. -1,70)


- what about timezone support? (obviously this is problematic as AS's date type and AEM's typeLongDateTime support current TZ only, but for general date manipulation tasks a script object wrapper, or (perhaps preferable from user's POV since it's transparent) a {class:date with timezone,time:...,timezone:...} record, could be defined that stores an arbitrary TZ in addition to standard date value); see also `time to GMT` in StandardAdditions (Q. would a `offset for timezone` command that returns difference between current tz and any other be more useful?); see also NSTimeZone


- what about adding optional `using current day/current time/OS X epoch/Unix epoch/classic Mac epoch` parameter to `datetime` for specifying default year/month/date/time (currently default values are hardcoded for OS X epoch)? also, what about optional `for first`, `for second`, etc. parameters for specifying first/second/third/fourth/fifth Monday/Tuesday/Wednesday/../Sunday in a month? 


- see also NSFormattingContext... constants in NSFormatter.h for fine-tuning capitalization for standalone/start-of-sentence/in-sentence use


- what about NSDateComponentsFormatter, NSDateIntervalFormatter?

     � 	 	N   D a t e   - -   m a k e ,   p a r s e ,   a n d   f o r m a t   d a t e s   a n d   d a t e   s t r i n g s 
 
 C a u t i o n : 
 
 -   A p p l e S c r i p t ' s   d a t e   o b j e c t s   a r e   m u t a b l e ( ! ) ,   s o   a n y   t i m e   a   n e w   d a t e   o b j e c t   i s   n e e d e d ,   e i t h e r   c o n s t r u c t   i t   f r o m   s c r a t c h   u s i n g   A S O C ' s   ` ( N S D a t e ' s   d a t e . . . ( ) )   a s   d a t e ` ,   S t a n d a r d   A d d i t i o n s '   ` c u r r e n t   d a t e `   c o m m a n d ,   o r   ` c o p y   _ d e f a u l t D a t e   t o   n e w D a t e `   a n d   w o r k   o n   t h e   * c o p y * .   N E V E R   u s e ,   m o d i f y ,   o r   r e t u r n   _ d e f a u l t D a t e   ( o r   a n y   o t h e r   r e t a i n e d   d a t e   o b j e c t )   d i r e c t l y ,   a s   a l l o w i n g   a   s h a r e d   m u t a b l e   o b j e c t   t o   e s c a p e   f r o m   t h i s   l i b r a r y   a n d   r u n   l o o s e   a r o u n d   u s e r s '   p r o g r a m s   i s   a   g u a r a n t e e d   r e c i p e   f o r   c h a o s   a n d   d i s a s t e r .   ( I t ' s   b a d   e n o u g h   w h e n   l i s t s   a n d   r e c o r d s   d o   t h i s ,   b u t   d a t e s   d o n ' t   l o o k   l i k e   m u t a b l e   c o l l e c t i o n s   s o   u s e r s   a r e   e v e n   l e s s   l i k e l y   t o   r e a l i z e   t h e y   c o n t a i n   s h a r e a b l e   s t a t e . ) 
 
 T O   D O :   
 
 -   s h o u l d   ` j o i n   d a t e `   i m p l e m e n t   o p t i o n a l   ` w i t h / w i t h o u t   r o l l o v e r   a l l o w e d `   p a r a m e t e r   t o   d e t e r m i n e   i f   o u t - o f - r a n g e   v a l u e s   s h o u l d   b e   a l l o w e d   t o   r o l l o v e r   o r   n o t   ( d e f a u l t :   e r r o r   i f   r o l l o v e r   d e t e c t e d )   c h e c k   f o r   a n y   o u t - o f - r a n g e   p r o p e r t i e s ,   a s   A S   w i l l   s i l e n t l y   r o l l   o v e r   ( Q .   w h a t   a b o u t   l e a p - s e c o n d s ? )   T B H ,   p r o b a b l y   b e   s i m p l e r   a n d   s a f e r   t o   r a n g e - c h e c k   y e a r + m o n t h + h o u r s + m i n u t e s   ( a l l   t h o s e   r a n g e s   a r e   f i x e d ,   s o   a s   l o n g   a s   t h e   r e c ' s   p r o p e r t i e s   a r e   a n y w h e r e   w i t h i n   t h o s e   r a n g e s   t h e y ' r e   o k ) ,   a n d   c o m p a r i s o n - c h e c k   t h e   d a y   ( a l l o w i n g   s o m e   f l e x i b i l i t y   i n   t h e   e v e n t   t h a t   a   l e a p   s e c o n d   n u d g e s   i t   o v e r   t o   t h e   n e x t   d a y ) ,   a n d   f i n a l l y   c h e c k   t h e   s e c o n d s   i s n ' t   o b v i o u s l y   i n v a l i d   ( e . g .   - 1 , 7 0 ) 
 
 
 -   w h a t   a b o u t   t i m e z o n e   s u p p o r t ?   ( o b v i o u s l y   t h i s   i s   p r o b l e m a t i c   a s   A S ' s   d a t e   t y p e   a n d   A E M ' s   t y p e L o n g D a t e T i m e   s u p p o r t   c u r r e n t   T Z   o n l y ,   b u t   f o r   g e n e r a l   d a t e   m a n i p u l a t i o n   t a s k s   a   s c r i p t   o b j e c t   w r a p p e r ,   o r   ( p e r h a p s   p r e f e r a b l e   f r o m   u s e r ' s   P O V   s i n c e   i t ' s   t r a n s p a r e n t )   a   { c l a s s : d a t e   w i t h   t i m e z o n e , t i m e : . . . , t i m e z o n e : . . . }   r e c o r d ,   c o u l d   b e   d e f i n e d   t h a t   s t o r e s   a n   a r b i t r a r y   T Z   i n   a d d i t i o n   t o   s t a n d a r d   d a t e   v a l u e ) ;   s e e   a l s o   ` t i m e   t o   G M T `   i n   S t a n d a r d A d d i t i o n s   ( Q .   w o u l d   a   ` o f f s e t   f o r   t i m e z o n e `   c o m m a n d   t h a t   r e t u r n s   d i f f e r e n c e   b e t w e e n   c u r r e n t   t z   a n d   a n y   o t h e r   b e   m o r e   u s e f u l ? ) ;   s e e   a l s o   N S T i m e Z o n e 
 
 
 -   w h a t   a b o u t   a d d i n g   o p t i o n a l   ` u s i n g   c u r r e n t   d a y / c u r r e n t   t i m e / O S   X   e p o c h / U n i x   e p o c h / c l a s s i c   M a c   e p o c h `   p a r a m e t e r   t o   ` d a t e t i m e `   f o r   s p e c i f y i n g   d e f a u l t   y e a r / m o n t h / d a t e / t i m e   ( c u r r e n t l y   d e f a u l t   v a l u e s   a r e   h a r d c o d e d   f o r   O S   X   e p o c h ) ?   a l s o ,   w h a t   a b o u t   o p t i o n a l   ` f o r   f i r s t ` ,   ` f o r   s e c o n d ` ,   e t c .   p a r a m e t e r s   f o r   s p e c i f y i n g   f i r s t / s e c o n d / t h i r d / f o u r t h / f i f t h   M o n d a y / T u e s d a y / W e d n e s d a y / . . / S u n d a y   i n   a   m o n t h ?   
 
 
 -   s e e   a l s o   N S F o r m a t t i n g C o n t e x t . . .   c o n s t a n t s   i n   N S F o r m a t t e r . h   f o r   f i n e - t u n i n g   c a p i t a l i z a t i o n   f o r   s t a n d a l o n e / s t a r t - o f - s e n t e n c e / i n - s e n t e n c e   u s e 
 
 
 -   w h a t   a b o u t   N S D a t e C o m p o n e n t s F o r m a t t e r ,   N S D a t e I n t e r v a l F o r m a t t e r ? 
 
   
  
 l     ��������  ��  ��        x     �� ����    4    �� 
�� 
frmk  m       �    F o u n d a t i o n��        x    �� ����    2   ��
�� 
osax��        l     ��������  ��  ��        l     ��  ��    J D--------------------------------------------------------------------     �   � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -      l     ��  ��      support     �        s u p p o r t   ! " ! l     ��������  ��  ��   "  # $ # l      % & ' % j    �� (�� 0 _support   ( N     ) ) 4    �� *
�� 
scpt * m     + + � , ,  T y p e S u p p o r t & "  used for parameter checking    ' � - - 8   u s e d   f o r   p a r a m e t e r   c h e c k i n g $  . / . l     ��������  ��  ��   /  0 1 0 i   ! 2 3 2 I      �� 4���� 
0 _error   4  5 6 5 o      ���� 0 handlername handlerName 6  7 8 7 o      ���� 0 etext eText 8  9 : 9 o      ���� 0 enumber eNumber :  ; < ; o      ���� 0 efrom eFrom <  =�� = o      ���� 
0 eto eTo��  ��   3 n     > ? > I    �� @���� &0 throwcommanderror throwCommandError @  A B A m     C C � D D  D a t e B  E F E o    ���� 0 handlername handlerName F  G H G o    ���� 0 etext eText H  I J I o    	���� 0 enumber eNumber J  K L K o   	 
���� 0 efrom eFrom L  M�� M o   
 ���� 
0 eto eTo��  ��   ? o     ���� 0 _support   1  N O N l     ��������  ��  ��   O  P Q P l     ��������  ��  ��   Q  R S R l     ��������  ��  ��   S  T U T i  " % V W V I      �������� $0 _makedefaultdate _makeDefaultDate��  ��   W l    E X Y Z X O     E [ \ [ k    D ] ]  ^ _ ^ r    ) ` a ` J     b b  c d c m    	����� d  e f e m   	 
����  f  g�� g m   
 ���� ��   a J       h h  i j i n      k l k 1    ��
�� 
year l  g     j  m n m n      o p o m    ��
�� 
mnth p  g     n  q�� q n      r s r 1   % '��
�� 
day  s  g   $ %��   _  t u t l  * A v w x v r   * A y z y J   * . { {  | } | m   * +����  }  ~�� ~ m   + ,����  ��   z J          � � � n      � � � m   4 6��
�� 
mnth �  g   3 4 �  ��� � n      � � � 1   = ?��
�� 
time �  g   < =��   w=7 note: month property normally needs set twice as it may have rolled over to next month if date's original `day` property was greater than no. of days in the new month (it doesn't actually matter in this particular case as January always has 31 days, but it's included anyway as a cautionary reminder to others)    x � � �n   n o t e :   m o n t h   p r o p e r t y   n o r m a l l y   n e e d s   s e t   t w i c e   a s   i t   m a y   h a v e   r o l l e d   o v e r   t o   n e x t   m o n t h   i f   d a t e ' s   o r i g i n a l   ` d a y `   p r o p e r t y   w a s   g r e a t e r   t h a n   n o .   o f   d a y s   i n   t h e   n e w   m o n t h   ( i t   d o e s n ' t   a c t u a l l y   m a t t e r   i n   t h i s   p a r t i c u l a r   c a s e   a s   J a n u a r y   a l w a y s   h a s   3 1   d a y s ,   b u t   i t ' s   i n c l u d e d   a n y w a y   a s   a   c a u t i o n a r y   r e m i n d e r   t o   o t h e r s ) u  ��� � L   B D � �  g   B C��   \ l     ����� � I    ������
�� .misccurdldt    ��� null��  ��  ��  ��   Y � � kludge that avoids having to use AppleScript's `date "..."` specifier syntax in this code (which requires the string literal to be written in the host system's localized date format, making the source code non-portable)    Z � � ��   k l u d g e   t h a t   a v o i d s   h a v i n g   t o   u s e   A p p l e S c r i p t ' s   ` d a t e   " . . . " `   s p e c i f i e r   s y n t a x   i n   t h i s   c o d e   ( w h i c h   r e q u i r e s   t h e   s t r i n g   l i t e r a l   t o   b e   w r i t t e n   i n   t h e   h o s t   s y s t e m ' s   l o c a l i z e d   d a t e   f o r m a t ,   m a k i n g   t h e   s o u r c e   c o d e   n o n - p o r t a b l e ) U  � � � l     ��������  ��  ��   �  � � � l      � � � � j   & ,�� ��� 0 _defaultdate _defaultDate � I   & +�������� $0 _makedefaultdate _makeDefaultDate��  ��   � 1 + 1 January 2001, 00:00:00, i.e. Cocoa epoch    � � � � V   1   J a n u a r y   2 0 0 1 ,   0 0 : 0 0 : 0 0 ,   i . e .   C o c o a   e p o c h �  � � � l     ��������  ��  ��   �  � � � j   - L�� ��� 0 _months   � J   - K � �  � � � m   - .��
�� 
jan  �  � � � m   . /��
�� 
feb  �  � � � m   / 0��
�� 
mar  �  � � � m   0 1��
�� 
apr  �  � � � m   1 2��
�� 
may  �  � � � m   2 5��
�� 
jun  �  � � � m   5 8��
�� 
jul  �  � � � m   8 ;��
�� 
aug  �  � � � m   ; >��
�� 
sep  �  � � � m   > A��
�� 
oct  �  � � � m   A D��
�� 
nov  �  ��� � m   D G��
�� 
dec ��   �  � � � j   M g�� ��� 0 	_weekdays   � J   M f � �  � � � m   M P��
�� 
mon  �  � � � m   P S��
�� 
tue  �  � � � m   S V��
�� 
wed  �  � � � m   V Y��
�� 
thu  �  � � � m   Y \��
�� 
fri  �  � � � m   \ _��
�� 
sat  �  ��� � m   _ b��
�� 
sun ��   �  � � � l     ��������  ��  ��   �  � � � l     ��������  ��  ��   �  � � � l     �� � ���   � J D--------------------------------------------------------------------    � � � � � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - �  � � � l     �� � ���   �   constants     � � � �    c o n s t a n t s   �  � � � l     ��������  ��  ��   �  � � � i  h k � � � I     ������
�� .Dat:Mthsnull��� ��� null��  ��   � l    	 � � � � L     	 � � n      � � � 2   ��
�� 
cobj � o     ���� 0 _months   � �  shallow copy list before returning it to ensure any changes the user might make to the returned list won't affect the original    � � � � �   s h a l l o w   c o p y   l i s t   b e f o r e   r e t u r n i n g   i t   t o   e n s u r e   a n y   c h a n g e s   t h e   u s e r   m i g h t   m a k e   t o   t h e   r e t u r n e d   l i s t   w o n ' t   a f f e c t   t h e   o r i g i n a l �  � � � l     ��������  ��  ��   �  � � � i  l o � � � I     ������
�� .Dat:Wkdsnull��� ��� null��  ��   � l    	 � � � � L     	 � � n      � � � 2   �
� 
cobj � o     �~�~ 0 	_weekdays   �   ditto    � � � �    d i t t o �  � � � l     �}�|�{�}  �|  �{   �  � � � l     �z�y�x�z  �y  �x   �  � � � l     �w � ��w   � J D--------------------------------------------------------------------    � � � � � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - �  � � � l     �v � ��v   �   dates    � � � �    d a t e s �  � � � l     �u�t�s�u  �t  �s   �  � � � l     �r � ��r   � D > TO DO: defaults? ISO8601? (confirm locale never affects this)    � � � � |   T O   D O :   d e f a u l t s ?   I S O 8 6 0 1 ?   ( c o n f i r m   l o c a l e   n e v e r   a f f e c t s   t h i s ) �    l     �q�p�o�q  �p  �o    i  p s I      �n�m�n 0 
_datestyle 
_dateStyle  o      �l�l 0 	theformat 	theFormat 	�k	 o      �j�j 0 formatstyles formatStyles�k  �m   k     �

  X     u�i k   I p  r   I ` o   I J�h�h 0 aref aRef J        o      �g�g 0 
formattype 
formatType  o      �f�f 0 isdate isDate �e o      �d�d 0 
asocoption 
asocOption�e   �c Z  a p�b�a =  a d o   a b�`�` 0 	theformat 	theFormat o   b c�_�_ 0 
formattype 
formatType L   g l J   g k   !"! o   g h�^�^ 0 isdate isDate" #�]# o   h i�\�\ 0 
asocoption 
asocOption�]  �b  �a  �c  �i 0 aref aRef J    =$$ %&% l 	  
'�[�Z' J    
(( )*) m    �Y
�Y FDStFDS1* +,+ m    �X
�X boovtrue, -�W- n   ./. o    �V�V 60 nsdateformattershortstyle NSDateFormatterShortStyle/ m    �U
�U misccura�W  �[  �Z  & 010 l 	 
 2�T�S2 J   
 33 454 m   
 �R
�R FDStFDS25 676 m    �Q
�Q boovtrue7 8�P8 n   9:9 o    �O�O 80 nsdateformattermediumstyle NSDateFormatterMediumStyle: m    �N
�N misccura�P  �T  �S  1 ;<; l 	  =�M�L= J    >> ?@? m    �K
�K FDStFDS3@ ABA m    �J
�J boovtrueB C�IC n   DED o    �H�H 40 nsdateformatterlongstyle NSDateFormatterLongStyleE m    �G
�G misccura�I  �M  �L  < FGF l 	  H�F�EH J    II JKJ m    �D
�D FDStFDS4K LML m    �C
�C boovtrueM N�BN n   OPO o    �A�A 40 nsdateformatterfullstyle NSDateFormatterFullStyleP m    �@
�@ misccura�B  �F  �E  G QRQ l 	  &S�?�>S J    &TT UVU m     �=
�= FDStFDS6V WXW m     !�<
�< boovfalsX Y�;Y n  ! $Z[Z o   " $�:�: 60 nsdateformattershortstyle NSDateFormatterShortStyle[ m   ! "�9
�9 misccura�;  �?  �>  R \]\ l 	 & -^�8�7^ J   & -__ `a` m   & '�6
�6 FDStFDS7a bcb m   ' (�5
�5 boovfalsc d�4d n  ( +efe o   ) +�3�3 80 nsdateformattermediumstyle NSDateFormatterMediumStylef m   ( )�2
�2 misccura�4  �8  �7  ] ghg l 	 - 4i�1�0i J   - 4jj klk m   - .�/
�/ FDStFDS8l mnm m   . /�.
�. boovfalsn o�-o n  / 2pqp o   0 2�,�, 40 nsdateformatterlongstyle NSDateFormatterLongStyleq m   / 0�+
�+ misccura�-  �1  �0  h r�*r l 	 4 ;s�)�(s J   4 ;tt uvu m   4 5�'
�' FDStFDS9v wxw m   5 6�&
�& boovfalsx y�%y n  6 9z{z o   7 9�$�$ 40 nsdateformatterfullstyle NSDateFormatterFullStyle{ m   6 7�#
�# misccura�%  �)  �(  �*   |�"| R   v ��!}~
�! .ascrerr ****      � ****} m   � � ��� h I n v a l i d    u s i n g    p a r a m e t e r   ( n o t   a n   a l l o w e d   c o n s t a n t ) .~ � ��
�  
errn� m   z }���Y� ���
� 
erob� o   � ��� 0 formatstyles formatStyles� ���
� 
errt� m   � ��
� 
enum�  �"   ��� l     ����  �  �  � ��� l     ����  �  �  � ��� i  t w��� I      ���� (0 _makedateformatter _makeDateFormatter� ��� o      �� 0 	theformat 	theFormat� ��� o      �� 0 
localecode 
localeCode�  �  � k    6�� ��� r     ��� n    ��� I    ���� 0 init  �  �  � n    ��� I    ��
�	� 	0 alloc  �
  �	  � n    ��� o    �� "0 nsdateformatter NSDateFormatter� m     �
� misccura� o      �� 0 asocformatter asocFormatter� ��� Z    ����� =    ��� l   ���� I   ���
� .corecnte****       ****� J    �� ��� o    � �  0 	theformat 	theFormat�  � �����
�� 
kocl� m    ��
�� 
ctxt��  �  �  � m    ����  � l  ���� k   �� ��� r    (��� n   &��� I   ! &������� "0 aslistparameter asListParameter� ���� o   ! "���� 0 	theformat 	theFormat��  ��  � o    !���� 0 _support  � o      ���� 0 formattypes formatTypes� ��� Z   ) Y������� =  ) .��� o   ) *���� 0 formattypes formatTypes� J   * -�� ���� m   * +��
�� FDStFDS0��  � k   1 U�� ��� r   1 >��� n  1 <��� I   8 <�������� 0 init  ��  ��  � n  1 8��� I   4 8�������� 	0 alloc  ��  ��  � n  1 4��� o   2 4���� "0 nsdateformatter NSDateFormatter� m   1 2��
�� misccura� o      ���� 0 asocformatter asocFormatter� ��� n  ? E��� I   @ E�������  0 setdateformat_ setDateFormat_� ���� m   @ A�� ��� 4 y y y y - M M - d d ' T ' H H : m m : s s Z Z Z Z Z��  ��  � o   ? @���� 0 asocformatter asocFormatter� ��� n  F R��� I   G R������� 0 
setlocale_ 
setLocale_� ���� l  G N������ n  G N��� I   J N�������� 0 systemlocale systemLocale��  ��  � n  G J��� o   H J���� 0 nslocale NSLocale� m   G H��
�� misccura��  ��  ��  ��  � o   F G���� 0 asocformatter asocFormatter� ���� L   S U�� o   S T���� 0 asocformatter asocFormatter��  ��  ��  � ��� n  Z b��� I   [ b������� 0 setdatestyle_ setDateStyle_� ���� l  [ ^������ n  [ ^��� o   \ ^���� 00 nsdateformatternostyle NSDateFormatterNoStyle� m   [ \��
�� misccura��  ��  ��  ��  � o   Z [���� 0 asocformatter asocFormatter� ��� n  c k��� I   d k������� 0 settimestyle_ setTimeStyle_� ���� l  d g������ n  d g��� o   e g���� 00 nsdateformatternostyle NSDateFormatterNoStyle� m   d e��
�� misccura��  ��  ��  ��  � o   c d���� 0 asocformatter asocFormatter� ��� r   l ���� J   l p�� ��� m   l m��
�� boovfals� ���� m   m n��
�� boovfals��  � J      �� ��� o      ���� 0 	isdateset 	isDateSet� ���� o      ���� 0 	istimeset 	isTimeSet��  � ���� X   ������ k   ���    r   � � I      ������ 0 
_datestyle 
_dateStyle  n  � � 1   � ���
�� 
pcnt o   � ����� 0 aref aRef 	��	 o   � ����� 0 	theformat 	theFormat��  ��   J      

  o      ���� 0 isdate isDate �� o      ���� 0 
asocoption 
asocOption��   �� Z   ��� o   � ����� 0 isdate isDate k   � �  Z  � ����� o   � ����� 0 	isdateset 	isDateSet R   � ���
�� .ascrerr ****      � **** m   � � � d I n v a l i d    u s i n g    p a r a m e t e r   ( t o o   m a n y   d a t e   f o r m a t s ) . ��
�� 
errn m   � ������Y ����
�� 
erob o   � ����� 0 formattypes formatTypes��  ��  ��    l  � � ����  n  � �!"! I   � ���#���� 0 setdatestyle_ setDateStyle_# $��$ o   � ����� 0 
asocoption 
asocOption��  ��  " o   � ����� 0 asocformatter asocFormatter��  ��   %��% r   � �&'& m   � ���
�� boovtrue' o      ���� 0 	isdateset 	isDateSet��  ��   k   �(( )*) Z  � �+,����+ o   � ����� 0 	istimeset 	isTimeSet, R   � ���-.
�� .ascrerr ****      � ****- m   � �// �00 d I n v a l i d    u s i n g    p a r a m e t e r   ( t o o   m a n y   t i m e   f o r m a t s ) .. ��12
�� 
errn1 m   � ������Y2 ��3��
�� 
erob3 o   � ����� 0 formattypes formatTypes��  ��  ��  * 454 l  �6����6 n  �787 I   ���9���� 0 settimestyle_ setTimeStyle_9 :��: o   � ����� 0 
asocoption 
asocOption��  ��  8 o   � ����� 0 asocformatter asocFormatter��  ��  5 ;��; r  <=< m  ��
�� boovtrue= o      ���� 0 	istimeset 	isTimeSet��  ��  �� 0 aref aRef� o   � ����� 0 formattypes formatTypes��  � < 6 use predefined date-style and/or time-style constants   � �>> l   u s e   p r e d e f i n e d   d a t e - s t y l e   a n d / o r   t i m e - s t y l e   c o n s t a n t s�  � l  ?@A? n  BCB I   ��D����  0 setdateformat_ setDateFormat_D E��E l F����F n GHG I  ��I���� "0 astextparameter asTextParameterI JKJ o  ���� 0 	theformat 	theFormatK L��L m  MM �NN 
 u s i n g��  ��  H o  ���� 0 _support  ��  ��  ��  ��  C o  ���� 0 asocformatter asocFormatter@   use custom format string   A �OO 2   u s e   c u s t o m   f o r m a t   s t r i n g� PQP n !3RSR I  "3��T��� 0 
setlocale_ 
setLocale_T U�~U l "/V�}�|V n "/WXW I  '/�{Y�z�{ *0 asnslocaleparameter asNSLocaleParameterY Z[Z o  '(�y�y 0 
localecode 
localeCode[ \�x\ m  (+]] �^^  f o r   l o c a l e�x  �z  X o  "'�w�w 0 _support  �}  �|  �~  �  S o  !"�v�v 0 asocformatter asocFormatterQ _�u_ L  46`` o  45�t�t 0 asocformatter asocFormatter�u  � aba l     �s�r�q�s  �r  �q  b cdc l     �p�o�n�p  �o  �n  d efe l     �m�l�k�m  �l  �k  f ghg i  x {iji I     �jkl
�j .Dat:FDatnull���     ldt k o      �i�i 0 thedate theDatel �hmn
�h 
Usinm |�g�fo�ep�g  �f  o o      �d�d 0 	theformat 	theFormat�e  p l     q�c�bq J      rr s�as m      �`
�` FDStFDS0�a  �c  �b  n �_t�^
�_ 
Locat |�]�\u�[v�]  �\  u o      �Z�Z 0 
localecode 
localeCode�[  v l     w�Y�Xw m      �W
�W 
msng�Y  �X  �^  j k     6xx yzy l     �V{|�V  { � � TO DO: what about optional `in timezone` parameter to specify timezone to use? (AS dates always use host machine's timezone, so extra info is needed to format dates for any other tz)   | �}}n   T O   D O :   w h a t   a b o u t   o p t i o n a l   ` i n   t i m e z o n e `   p a r a m e t e r   t o   s p e c i f y   t i m e z o n e   t o   u s e ?   ( A S   d a t e s   a l w a y s   u s e   h o s t   m a c h i n e ' s   t i m e z o n e ,   s o   e x t r a   i n f o   i s   n e e d e d   t o   f o r m a t   d a t e s   f o r   a n y   o t h e r   t z )z ~�U~ Q     6�� k    $�� ��� r    ��� n   ��� I    �T��S�T "0 asdateparameter asDateParameter� ��� o    	�R�R 0 thedate theDate� ��Q� m   	 
�� ���  �Q  �S  � o    �P�P 0 _support  � o      �O�O 0 thedate theDate� ��� r    ��� I    �N��M�N (0 _makedateformatter _makeDateFormatter� ��� o    �L�L 0 	theformat 	theFormat� ��K� o    �J�J 0 
localecode 
localeCode�K  �M  � o      �I�I 0 asocformatter asocFormatter� ��H� L    $�� c    #��� l   !��G�F� n   !��� I    !�E��D�E "0 stringfromdate_ stringFromDate_� ��C� o    �B�B 0 thedate theDate�C  �D  � o    �A�A 0 asocformatter asocFormatter�G  �F  � m   ! "�@
�@ 
ctxt�H  � R      �?��
�? .ascrerr ****      � ****� o      �>�> 0 etext eText� �=��
�= 
errn� o      �<�< 0 enumber eNumber� �;��
�; 
erob� o      �:�: 0 efrom eFrom� �9��8
�9 
errt� o      �7�7 
0 eto eTo�8  � I   , 6�6��5�6 
0 _error  � ��� m   - .�� ���  f o r m a t   d a t e� ��� o   . /�4�4 0 etext eText� ��� o   / 0�3�3 0 enumber eNumber� ��� o   0 1�2�2 0 efrom eFrom� ��1� o   1 2�0�0 
0 eto eTo�1  �5  �U  h ��� l     �/�.�-�/  �.  �-  � ��� l     �,�+�*�,  �+  �*  � ��� i  | ��� I     �)��
�) .Dat:PDatnull���     ctxt� o      �(�( 0 thetext theText� �'��
�' 
Usin� |�&�%��$��&  �%  � o      �#�# 0 	theformat 	theFormat�$  � l     ��"�!� J      �� �� � m      �
� FDStFDS0�   �"  �!  � ���
� 
Loca� |������  �  � o      �� 0 
localecode 
localeCode�  � l     ���� m      �
� 
msng�  �  �  � Q     ����� k    ��� ��� r    ��� n   ��� I    ���� &0 stringwithstring_ stringWithString_� ��� l   ���� n   ��� I    ���� "0 astextparameter asTextParameter� ��� o    �� 0 thetext theText� ��� m    �� ���  �  �  � o    �� 0 _support  �  �  �  �  � n   ��� o    �� 0 nsstring NSString� m    �

�
 misccura� o      �	�	 0 asoctext asocText� ��� r    !��� I    ���� (0 _makedateformatter _makeDateFormatter� ��� o    �� 0 	theformat 	theFormat� ��� o    �� 0 
localecode 
localeCode�  �  � o      �� 0 asocformatter asocFormatter� ��� r   " *��� n  " (��� I   # (���� "0 datefromstring_ dateFromString_� �� � o   # $���� 0 thetext theText�   �  � o   " #���� 0 asocformatter asocFormatter� o      ���� 0 asocdate asocDate� ��� Z   + y������� =  + .��� o   + ,���� 0 asocdate asocDate� m   , -��
�� 
msng� k   1 u�� ��� r   1 >��� c   1 <��� n  1 :��� I   6 :�������� $0 localeidentifier localeIdentifier��  ��  � n  1 6��� I   2 6�������� 
0 locale  ��  ��  � o   1 2���� 0 asocformatter asocFormatter� m   : ;��
�� 
ctxt� o      ���� $0 localeidentifier localeIdentifier�    Z   ? T�� =   ? D n  ? B 1   @ B��
�� 
leng o   ? @���� $0 localeidentifier localeIdentifier m   B C����   r   G J	
	 m   G H �  s t a n d a r d
 o      ���� $0 localeidentifier localeIdentifier��   r   M T b   M R b   M P m   M N �   o   N O���� $0 localeidentifier localeIdentifier m   P Q �   o      ���� $0 localeidentifier localeIdentifier �� R   U u��
�� .ascrerr ****      � **** l  a t���� b   a t b   a p b   a n  b   a j!"! m   a d## �$$ t T e x t   i s   n o t   i n   t h e   c o r r e c t   f o r m a t   ( e x p e c t e d   d a t e   t e x t   i n   " l  d i%����% n  d i&'& I   e i�������� 0 
dateformat 
dateFormat��  ��  ' o   d e���� 0 asocformatter asocFormatter��  ��    m   j m(( �)) "    f o r m a t   f o r   t h e   o   n o���� $0 localeidentifier localeIdentifier m   p s** �++    l o c a l e . )��  ��   ��,-
�� 
errn, m   W Z�����Y- ��.��
�� 
erob. o   ] ^���� 0 thetext theText��  ��  ��  ��  � /0/ l   z z��12��  1��
		-- note: -getObjectValue:forString:range:error: would be preferable to -dateFromString: as it returns an error description; however, it only parses the string as far as it can so the caller must check the returned range to determine if the entire string was consumed and raise its own error if not, but this currently isn't possible in ASOC as it only supports `in` and `out` arguments, not `inout` (OTOH, Cocoa-generated error messages often aren't much better than generic ones, so it's not a massive loss)
		set {didSucceed, asocDate, theError} to asocFormatter's getObjectValue:(specifier) forString:asocText range:({location:0, |length|:asocText's |length|()}) |error|:(specifier)
		if not didSucceed then
			...
			error ((theError's localizedDescription() as text) & " (Expected date text in �" & (asocFormatter's dateFormat()) & "� format for the " & localeIdentifier & " locale.)") number -1703 from theText
		end if
		   2 �33F 
 	 	 - -   n o t e :   - g e t O b j e c t V a l u e : f o r S t r i n g : r a n g e : e r r o r :   w o u l d   b e   p r e f e r a b l e   t o   - d a t e F r o m S t r i n g :   a s   i t   r e t u r n s   a n   e r r o r   d e s c r i p t i o n ;   h o w e v e r ,   i t   o n l y   p a r s e s   t h e   s t r i n g   a s   f a r   a s   i t   c a n   s o   t h e   c a l l e r   m u s t   c h e c k   t h e   r e t u r n e d   r a n g e   t o   d e t e r m i n e   i f   t h e   e n t i r e   s t r i n g   w a s   c o n s u m e d   a n d   r a i s e   i t s   o w n   e r r o r   i f   n o t ,   b u t   t h i s   c u r r e n t l y   i s n ' t   p o s s i b l e   i n   A S O C   a s   i t   o n l y   s u p p o r t s   ` i n `   a n d   ` o u t `   a r g u m e n t s ,   n o t   ` i n o u t `   ( O T O H ,   C o c o a - g e n e r a t e d   e r r o r   m e s s a g e s   o f t e n   a r e n ' t   m u c h   b e t t e r   t h a n   g e n e r i c   o n e s ,   s o   i t ' s   n o t   a   m a s s i v e   l o s s ) 
 	 	 s e t   { d i d S u c c e e d ,   a s o c D a t e ,   t h e E r r o r }   t o   a s o c F o r m a t t e r ' s   g e t O b j e c t V a l u e : ( s p e c i f i e r )   f o r S t r i n g : a s o c T e x t   r a n g e : ( { l o c a t i o n : 0 ,   | l e n g t h | : a s o c T e x t ' s   | l e n g t h | ( ) } )   | e r r o r | : ( s p e c i f i e r ) 
 	 	 i f   n o t   d i d S u c c e e d   t h e n 
 	 	 	 . . . 
 	 	 	 e r r o r   ( ( t h e E r r o r ' s   l o c a l i z e d D e s c r i p t i o n ( )   a s   t e x t )   &   "   ( E x p e c t e d   d a t e   t e x t   i n    "   &   ( a s o c F o r m a t t e r ' s   d a t e F o r m a t ( ) )   &   "    f o r m a t   f o r   t h e   "   &   l o c a l e I d e n t i f i e r   &   "   l o c a l e . ) " )   n u m b e r   - 1 7 0 3   f r o m   t h e T e x t 
 	 	 e n d   i f 
 	 	0 4��4 l  z �5675 L   z �88 c   z 9:9 o   z {���� 0 asocdate asocDate: m   { ~��
�� 
ldt 6 � � note that AS dates don't include timezone info, so resulting date object always uses host machine's current tz, regardless of what tz theText used, adjusting the date object's time appropriately   7 �;;�   n o t e   t h a t   A S   d a t e s   d o n ' t   i n c l u d e   t i m e z o n e   i n f o ,   s o   r e s u l t i n g   d a t e   o b j e c t   a l w a y s   u s e s   h o s t   m a c h i n e ' s   c u r r e n t   t z ,   r e g a r d l e s s   o f   w h a t   t z   t h e T e x t   u s e d ,   a d j u s t i n g   t h e   d a t e   o b j e c t ' s   t i m e   a p p r o p r i a t e l y��  � R      ��<=
�� .ascrerr ****      � ****< o      ���� 0 etext eText= ��>?
�� 
errn> o      ���� 0 enumber eNumber? ��@A
�� 
erob@ o      ���� 0 efrom eFromA ��B��
�� 
errtB o      ���� 
0 eto eTo��  � I   � ���C���� 
0 _error  C DED m   � �FF �GG  p a r s e   d a t eE HIH o   � ����� 0 etext eTextI JKJ o   � ����� 0 enumber eNumberK LML o   � ����� 0 efrom eFromM N��N o   � ����� 
0 eto eTo��  ��  � OPO l     ��������  ��  ��  P QRQ l     ��������  ��  ��  R STS l     ��UV��  U J D--------------------------------------------------------------------   V �WW � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -T XYX l     ��Z[��  Z   Date creation   [ �\\    D a t e   c r e a t i o nY ]^] l     ��������  ��  ��  ^ _`_ l     ��ab��  aic robust alternatives to `date TEXT` specifier for constructing date objects, (`date dateString` has serious portability and usability problems as it requires a precisely formatted *localized* date string): `join date` takes a record of numeric year/month/day/etc values; see also `parse date`, which takes date text in a stable format (ISO8601) by default   b �cc�   r o b u s t   a l t e r n a t i v e s   t o   ` d a t e   T E X T `   s p e c i f i e r   f o r   c o n s t r u c t i n g   d a t e   o b j e c t s ,   ( ` d a t e   d a t e S t r i n g `   h a s   s e r i o u s   p o r t a b i l i t y   a n d   u s a b i l i t y   p r o b l e m s   a s   i t   r e q u i r e s   a   p r e c i s e l y   f o r m a t t e d   * l o c a l i z e d *   d a t e   s t r i n g ) :   ` j o i n   d a t e `   t a k e s   a   r e c o r d   o f   n u m e r i c   y e a r / m o n t h / d a y / e t c   v a l u e s ;   s e e   a l s o   ` p a r s e   d a t e ` ,   w h i c h   t a k e s   d a t e   t e x t   i n   a   s t a b l e   f o r m a t   ( I S O 8 6 0 1 )   b y   d e f a u l t` ded l     ��������  ��  ��  e fgf l     ��������  ��  ��  g hih i  � �jkj I     ��l��
�� .Dat:ReDanull��� ��� WebCl |����m��n��  ��  m o      ����  0 dateproperties dateProperties��  n l     o����o J      ����  ��  ��  ��  k Q    pqrp k   �ss tut s    vwv o    ���� 0 _defaultdate _defaultDatew o      ���� 0 newdate newDateu xyx l   *z{|z r    *}~} l   (���� b    (��� n   ��� I    ������� &0 asrecordparameter asRecordParameter� ��� o    ����  0 dateproperties dateProperties� ���� m    �� ���  ��  ��  � o    ���� 0 _support  � K    '�� ����
�� 
year� m    ������ ����
�� 
mnth� m    ���� � ����
�� 
day � m    ���� � ����
�� 
hour� m    ����  � ����
�� 
min � m     !����  � ����
�� 
scnd� m   " #����  � �����
�� 
time� m   $ %��
�� 
msng��  ��  ��  ~ o      ���� 0 rec  { @ : use the Cocoa epoch (1 January 2001, 00:00:00) as default   | ��� t   u s e   t h e   C o c o a   e p o c h   ( 1   J a n u a r y   2 0 0 1 ,   0 0 : 0 0 : 0 0 )   a s   d e f a u l ty ��� Q   + X���� r   . 7��� c   . 3��� n  . 1��� 1   / 1��
�� 
year� o   . /���� 0 rec  � m   1 2��
�� 
long� n     ��� 1   4 6��
�� 
year� o   3 4���� 0 newdate newDate� R      ����
�� .ascrerr ****      � ****� o      ���� 0 etext eText� �����
�� 
errn� d      �� m      �������  � R   ? X����
�� .ascrerr ****      � ****� b   R W��� m   R U�� ��� 2 I n v a l i d    y e a r    p r o p e r t y :  � o   U V���� 0 etext eText� ����
�� 
errn� m   A D�����Y� ����
�� 
erob� l  G K������ N   G K�� n   G J��� 1   H J�
� 
year� o   G H�~�~  0 dateproperties dateProperties��  ��  � �}��|
�} 
errt� m   N O�{
�{ 
long�|  � ��� Z   Y ����z�� E  Y d��� o   Y ^�y�y 0 _months  � J   ^ c�� ��x� n  ^ a��� m   _ a�w
�w 
mnth� o   ^ _�v�v 0 rec  �x  � l  g n���� r   g n��� n  g j��� m   h j�u
�u 
mnth� o   g h�t�t 0 rec  � n     ��� m   k m�s
�s 
mnth� o   j k�r�r 0 newdate newDate� unlike year/day/time properties, which require numbers, a date object's `month` property accepts either an integer or a month constant; however, it also happily accepts weekday constants which is obviously wrong, so make sure a given constant is a valid month before assigning it   � ���0   u n l i k e   y e a r / d a y / t i m e   p r o p e r t i e s ,   w h i c h   r e q u i r e   n u m b e r s ,   a   d a t e   o b j e c t ' s   ` m o n t h `   p r o p e r t y   a c c e p t s   e i t h e r   a n   i n t e g e r   o r   a   m o n t h   c o n s t a n t ;   h o w e v e r ,   i t   a l s o   h a p p i l y   a c c e p t s   w e e k d a y   c o n s t a n t s   w h i c h   i s   o b v i o u s l y   w r o n g ,   s o   m a k e   s u r e   a   g i v e n   c o n s t a n t   i s   a   v a l i d   m o n t h   b e f o r e   a s s i g n i n g   i t�z  � l  q ����� Q   q ����� r   t }��� c   t y��� n  t w��� m   u w�q
�q 
mnth� o   t u�p�p 0 rec  � m   w x�o
�o 
long� n     ��� m   z |�n
�n 
mnth� o   y z�m�m 0 newdate newDate� R      �l��
�l .ascrerr ****      � ****� o      �k�k 0 etext eText� �j��i
�j 
errn� d      �� m      �h�h��i  � R   � ��g��
�g .ascrerr ****      � ****� b   � ���� m   � ��� ��� 4 I n v a l i d    m o n t h    p r o p e r t y :  � o   � ��f�f 0 etext eText� �e��
�e 
errn� m   � ��d�d�Y� �c��
�c 
erob� l  � ���b�a� N   � ��� n   � ���� m   � ��`
�` 
mnth� o   � ��_�_  0 dateproperties dateProperties�b  �a  � �^��]
�^ 
errt� J   � ��� ��� m   � ��\
�\ 
enum� ��[� m   � ��Z
�Z 
long�[  �]  � , & otherwise it must be an integer value   � ��� L   o t h e r w i s e   i t   m u s t   b e   a n   i n t e g e r   v a l u e� ��� Q   � ����� r   � ���� c   � ���� n  � ���� 1   � ��Y
�Y 
day � o   � ��X�X 0 rec  � m   � ��W
�W 
long� n     � � 1   � ��V
�V 
day   o   � ��U�U 0 newdate newDate� R      �T
�T .ascrerr ****      � **** o      �S�S 0 etext eText �R�Q
�R 
errn d       m      �P�P��Q  � R   � ��O
�O .ascrerr ****      � **** b   � � m   � �		 �

 0 I n v a l i d    d a y    p r o p e r t y :   o   � ��N�N 0 etext eText �M
�M 
errn m   � ��L�L�Y �K
�K 
erob l  � ��J�I N   � � n   � � 1   � ��H
�H 
day  o   � ��G�G  0 dateproperties dateProperties�J  �I   �F�E
�F 
errt m   � ��D
�D 
long�E  �  Z   �1�C�B F   � F   � � =   � � l  � ��A�@ I  � ��? 
�? .corecnte****       **** J   � �!! "�>" n  � �#$# m   � ��=
�= 
mnth$ o   � ��<�< 0 rec  �>    �;%�:
�; 
kocl% m   � ��9
�9 
nmbr�:  �A  �@   m   � ��8�8   =   � �&'& l  � �(�7�6( I  � ��5)*
�5 .corecnte****       ****) J   � �++ ,�4, n  � �-.- m   � ��3
�3 
mnth. o   � ��2�2 0 rec  �4  * �1/�0
�1 
kocl/ m   � ��/
�/ 
ctxt�0  �7  �6  ' m   � ��.�.   H   �
00 E  �	121 o   ��-�- 0 _months  2 J  33 4�,4 n 565 m  �+
�+ 
mnth6 o  �*�* 0 rec  �,   l -7897 R  -�):;
�) .ascrerr ****      � ****: m  ),<< �== p I n v a l i d    m o n t h    p r o p e r t y   ( e x p e c t e d   i n t e g e r   o r   c o n s t a n t ) .; �(>?
�( 
errn> m  �'�'�Y? �&@A
�& 
erob@ l B�%�$B N  CC n  DED m  �#
�# 
mnthE o  �"�"  0 dateproperties dateProperties�%  �$  A �!F� 
�! 
errtF J   &GG HIH m   #�
� 
enumI J�J m  #$�
� 
long�  �   8 o i TO DO: revise this: first check for constant and cast if found, then try integer cast and error if fails   9 �KK �   T O   D O :   r e v i s e   t h i s :   f i r s t   c h e c k   f o r   c o n s t a n t   a n d   c a s t   i f   f o u n d ,   t h e n   t r y   i n t e g e r   c a s t   a n d   e r r o r   i f   f a i l s�C  �B   LML Z  2�NO�PN = 27QRQ n 25STS 1  35�
� 
timeT o  23�� 0 rec  R m  56�
� 
msngO k  :�UU VWV Q  :iXYZX r  =H[\[ [  =F]^] o  =>�� 0 newdate newDate^ ]  >E_`_ l >?a��a 1  >?�
� 
hour�  �  ` l ?Db��b c  ?Dcdc n ?Befe 1  @B�
� 
hourf o  ?@�� 0 rec  d m  BC�
� 
long�  �  \ o      �� 0 newdate newDateY R      �gh
� .ascrerr ****      � ****g o      �� 0 etext eTexth �i�
� 
errni d      jj m      �
�
��  Z R  Pi�	kl
�	 .ascrerr ****      � ****k b  chmnm m  cfoo �pp 4 I n v a l i d    h o u r s    p r o p e r t y :  n o  fg�� 0 etext eTextl �qr
� 
errnq m  RU���Yr �st
� 
erobs l X\u��u N  X\vv n  X[wxw 1  Y[�
� 
hourx o  XY��  0 dateproperties dateProperties�  �  t � y��
�  
errty m  _`��
�� 
long��  W z{z Q  j�|}~| r  mx� [  mv��� o  mn���� 0 newdate newDate� ]  nu��� l no������ 1  no��
�� 
min ��  ��  � l ot������ c  ot��� n or��� 1  pr��
�� 
min � o  op���� 0 rec  � m  rs��
�� 
long��  ��  � o      ���� 0 newdate newDate} R      ����
�� .ascrerr ****      � ****� o      ���� 0 etext eText� �����
�� 
errn� d      �� m      �������  ~ R  ������
�� .ascrerr ****      � ****� b  ����� m  ���� ��� 8 I n v a l i d    m i n u t e s    p r o p e r t y :  � o  ������ 0 etext eText� ����
�� 
errn� m  �������Y� ����
�� 
erob� l �������� N  ���� n  ����� 1  ����
�� 
min � o  ������  0 dateproperties dateProperties��  ��  � �����
�� 
errt� m  ����
�� 
long��  { ���� Q  ������ r  ����� [  ����� o  ������ 0 newdate newDate� l �������� c  ����� n ����� m  ����
�� 
scnd� o  ������ 0 rec  � m  ����
�� 
long��  ��  � o      ���� 0 newdate newDate� R      ����
�� .ascrerr ****      � ****� o      ���� 0 etext eText� �����
�� 
errn� d      �� m      �������  � R  ������
�� .ascrerr ****      � ****� b  ����� m  ���� ��� 8 I n v a l i d    s e c o n d s    p r o p e r t y :  � o  ������ 0 etext eText� ����
�� 
errn� m  �������Y� ����
�� 
erob� l �������� N  ���� n  ����� m  ����
�� 
scnd� o  ������  0 dateproperties dateProperties��  ��  � �����
�� 
errt� m  ����
�� 
long��  ��  �  P Q  ������ r  ����� c  ����� n ����� 1  ����
�� 
time� o  ������ 0 rec  � m  ����
�� 
long� n     ��� 1  ����
�� 
time� o  ������ 0 newdate newDate� R      ����
�� .ascrerr ****      � ****� o      ���� 0 etext eText� �����
�� 
errn� d      �� m      �������  � R  ������
�� .ascrerr ****      � ****� b  ����� m  ���� ��� 2 I n v a l i d    t i m e    p r o p e r t y :  � o  ������ 0 etext eText� ����
�� 
errn� m  �������Y� ����
�� 
erob� l �������� N  ���� n  ����� 1  ����
�� 
time� o  ������  0 dateproperties dateProperties��  ��  � �����
�� 
errt� m  ����
�� 
long��  M ���� L  ���� o  ������ 0 newdate newDate��  q R      ����
�� .ascrerr ****      � ****� o      ���� 0 etext eText� ����
�� 
errn� o      ���� 0 enumber eNumber� ����
�� 
erob� o      ���� 0 efrom eFrom� �����
�� 
errt� o      ���� 
0 eto eTo��  r I  ������� 
0 _error  � ��� m  �� ���  j o i n   d a t e� ��� o  ���� 0 etext eText� ��� o  ���� 0 enumber eNumber� ��� o  	���� 0 efrom eFrom� ���� o  	
���� 
0 eto eTo��  ��  i ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� i  � ���� I     �����
�� .Dat:DaRenull��� ��� ldt � |����������  ��  � o      ���� 0 thedate theDate��  � l     ������ m      ��
�� 
msng��  ��  ��  � Q     ^���� k    H    Z     �� =    o    ���� 0 thedate theDate m    ��
�� 
msng r   	 	 o   	 ���� 0 _defaultdate _defaultDate	 o      ���� 0 thedate theDate��   r     

 n    I    ������ "0 asdateparameter asDateParameter  o    ���� 0 thedate theDate �� m     �  ��  ��   o    ���� 0 _support   o      ���� 0 thedate theDate �� L   ! H K   ! G ��
�� 
year n  " & 1   # %��
�� 
year o   " #���� 0 thedate theDate ��
�� 
mnth c   ' , n  ' *  m   ( *��
�� 
mnth  o   ' (���� 0 thedate theDate m   * +��
�� 
long �!"
� 
day ! n  - 1#$# 1   . 0�~
�~ 
day $ o   - .�}�} 0 thedate theDate" �|%&
�| 
hour% _   2 7'(' l  2 5)�{�z) n  2 5*+* 1   3 5�y
�y 
time+ o   2 3�x�x 0 thedate theDate�{  �z  ( m   5 6�w�w& �v,-
�v 
min , `   8 ?./. _   8 =010 l  8 ;2�u�t2 n  8 ;343 1   9 ;�s
�s 
time4 o   8 9�r�r 0 thedate theDate�u  �t  1 m   ; <�q�q </ m   = >�p�p <- �o5�n
�o 
scnd5 `   @ E676 l  @ C8�m�l8 n  @ C9:9 1   A C�k
�k 
time: o   @ A�j�j 0 thedate theDate�m  �l  7 m   C D�i�i <�n  ��  � R      �h;<
�h .ascrerr ****      � ****; o      �g�g 0 etext eText< �f=>
�f 
errn= o      �e�e 0 enumber eNumber> �d?@
�d 
erob? o      �c�c 0 efrom eFrom@ �bA�a
�b 
errtA o      �`�` 
0 eto eTo�a  � I   P ^�_B�^�_ 
0 _error  B CDC m   Q TEE �FF  s p l i t   d a t eD GHG o   T U�]�] 0 etext eTextH IJI o   U V�\�\ 0 enumber eNumberJ KLK o   V W�[�[ 0 efrom eFromL M�ZM o   W X�Y�Y 
0 eto eTo�Z  �^  � NON l     �X�W�V�X  �W  �V  O P�UP l     �T�S�R�T  �S  �R  �U       �QQRSTUVWXYZ[\]^_`�Q  Q �P�O�N�M�L�K�J�I�H�G�F�E�D�C�B
�P 
pimr�O 0 _support  �N 
0 _error  �M $0 _makedefaultdate _makeDefaultDate�L 0 _defaultdate _defaultDate�K 0 _months  �J 0 	_weekdays  
�I .Dat:Mthsnull��� ��� null
�H .Dat:Wkdsnull��� ��� null�G 0 
_datestyle 
_dateStyle�F (0 _makedateformatter _makeDateFormatter
�E .Dat:FDatnull���     ldt 
�D .Dat:PDatnull���     ctxt
�C .Dat:ReDanull��� ��� WebC
�B .Dat:DaRenull��� ��� ldt R �Aa�A a  bcb �@d�?
�@ 
cobjd ee   �> 
�> 
frmk�?  c �=f�<
�= 
cobjf gg   �;
�; 
osax�<  S hh   �: +
�: 
scptT �9 3�8�7ij�6�9 
0 _error  �8 �5k�5 k  �4�3�2�1�0�4 0 handlername handlerName�3 0 etext eText�2 0 enumber eNumber�1 0 efrom eFrom�0 
0 eto eTo�7  i �/�.�-�,�+�/ 0 handlername handlerName�. 0 etext eText�- 0 enumber eNumber�, 0 efrom eFrom�+ 
0 eto eToj  C�*�)�* �) &0 throwcommanderror throwCommandError�6 b  ࠡ����+ U �( W�'�&lm�%�( $0 _makedefaultdate _makeDefaultDate�'  �&  l  m �$�#�"�!� ��
�$ .misccurdldt    ��� null�#�
�" 
cobj
�! 
year
�  
mnth
� 
day 
� 
time�% F*j   >�kkmvE[�k/*�,FZ[�l/*�,FZ[�m/*�,FZOkjlvE[�k/*�,FZ[�l/*�,FZO*UV ldt     �uy W �n� n  ������������
� 
jan 
� 
feb 
� 
mar 
� 
apr 
� 
may 
� 
jun 
� 
jul 
� 
aug 
� 
sep 
� 
oct 
� 
nov 
� 
dec X �o� o  ������
�	
� 
mon 
� 
tue 
� 
wed 
� 
thu 
� 
fri 
�
 
sat 
�	 
sun Y � ���pq�
� .Dat:Mthsnull��� ��� null�  �  p  q �
� 
cobj� 
b  �-EZ � ���rs� 
� .Dat:Wkdsnull��� ��� null�  �  r  s ��
�� 
cobj�  
b  �-E[ ������tu���� 0 
_datestyle 
_dateStyle�� ��v�� v  ������ 0 	theformat 	theFormat�� 0 formatstyles formatStyles��  t �������������� 0 	theformat 	theFormat�� 0 formatstyles formatStyles�� 0 aref aRef�� 0 
formattype 
formatType�� 0 isdate isDate�� 0 
asocoption 
asocOptionu ����������������������������������������������
�� FDStFDS1
�� misccura�� 60 nsdateformattershortstyle NSDateFormatterShortStyle
�� FDStFDS2�� 80 nsdateformattermediumstyle NSDateFormatterMediumStyle
�� FDStFDS3�� 40 nsdateformatterlongstyle NSDateFormatterLongStyle
�� FDStFDS4�� 40 nsdateformatterfullstyle NSDateFormatterFullStyle
�� FDStFDS6
�� FDStFDS7
�� FDStFDS8
�� FDStFDS9�� 
�� 
kocl
�� 
cobj
�� .corecnte****       ****
�� 
errn���Y
�� 
erob
�� 
errt
�� 
enum�� �� � t�e��,mv�e��,mv�e��,mv�e��,mv�f��,mv�f��,mv�f��,mv�f��,mv�v[��l kh �E[�k/E�Z[�l/E�Z[�m/E�ZO��  
��lvY h[OY��O)a a a �a a a a \ �������wx���� (0 _makedateformatter _makeDateFormatter�� ��y�� y  ������ 0 	theformat 	theFormat�� 0 
localecode 
localeCode��  w 	�������������������� 0 	theformat 	theFormat�� 0 
localecode 
localeCode�� 0 asocformatter asocFormatter�� 0 formattypes formatTypes�� 0 	isdateset 	isDateSet�� 0 	istimeset 	isTimeSet�� 0 aref aRef�� 0 isdate isDate�� 0 
asocoption 
asocOptionx �����������������������������������������������/M��]��
�� misccura�� "0 nsdateformatter NSDateFormatter�� 	0 alloc  �� 0 init  
�� 
kocl
�� 
ctxt
�� .corecnte****       ****�� "0 aslistparameter asListParameter
�� FDStFDS0��  0 setdateformat_ setDateFormat_�� 0 nslocale NSLocale�� 0 systemlocale systemLocale�� 0 
setlocale_ 
setLocale_�� 00 nsdateformatternostyle NSDateFormatterNoStyle�� 0 setdatestyle_ setDateStyle_�� 0 settimestyle_ setTimeStyle_
�� 
cobj
�� 
pcnt�� 0 
_datestyle 
_dateStyle
�� 
errn���Y
�� 
erob�� �� "0 astextparameter asTextParameter�� *0 asnslocaleparameter asNSLocaleParameter��7��,j+ j+ E�O�kv��l j  �b  �k+ E�O��kv  )��,j+ j+ E�O��k+ 
O���,j+ k+ O�Y hO���,k+ O���,k+ OfflvE[a k/E�Z[a l/E�ZO ��[�a l kh *�a ,�l+ E[a k/E�Z[a l/E�ZO� *� )a a a �a a Y hO��k+ OeE�Y '� )a a a �a a Y hO��k+ OeE�[OY��Y �b  �a l+ k+ 
O�b  �a l+ k+ O�] ��j����z{��
�� .Dat:FDatnull���     ldt �� 0 thedate theDate�� ��|}
�� 
Usin| {����~�� 0 	theformat 	theFormat��  ~ ����   ��
�� FDStFDS0} �����
�� 
Loca� {�������� 0 
localecode 
localeCode��  
�� 
msng��  z ������������������ 0 thedate theDate�� 0 	theformat 	theFormat�� 0 
localecode 
localeCode�� 0 asocformatter asocFormatter�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo{ 
������������������� "0 asdateparameter asDateParameter�� (0 _makedateformatter _makeDateFormatter�� "0 stringfromdate_ stringFromDate_
�� 
ctxt�� 0 etext eText� �����
�� 
errn�� 0 enumber eNumber� �����
�� 
erob�� 0 efrom eFrom� ������
�� 
errt�� 
0 eto eTo��  �� �� 
0 _error  �� 7 &b  ��l+ E�O*��l+ E�O��k+ �&W X  *礥���+ 	^ �����������
�� .Dat:PDatnull���     ctxt�� 0 thetext theText�� ����
�� 
Usin� {������� 0 	theformat 	theFormat��  � ����� �  ��
�� FDStFDS0� �����
�� 
Loca� {�������� 0 
localecode 
localeCode��  
�� 
msng��  � ��~�}�|�{�z�y�x�w�v�u� 0 thetext theText�~ 0 	theformat 	theFormat�} 0 
localecode 
localeCode�| 0 asoctext asocText�{ 0 asocformatter asocFormatter�z 0 asocdate asocDate�y $0 localeidentifier localeIdentifier�x 0 etext eText�w 0 enumber eNumber�v 0 efrom eFrom�u 
0 eto eTo� �t�s��r�q�p�o�n�m�l�k�j�i�h�g�f#�e(*�d�c�F�b�a
�t misccura�s 0 nsstring NSString�r "0 astextparameter asTextParameter�q &0 stringwithstring_ stringWithString_�p (0 _makedateformatter _makeDateFormatter�o "0 datefromstring_ dateFromString_
�n 
msng�m 
0 locale  �l $0 localeidentifier localeIdentifier
�k 
ctxt
�j 
leng
�i 
errn�h�Y
�g 
erob�f �e 0 
dateformat 
dateFormat
�d 
ldt �c 0 etext eText� �`�_�
�` 
errn�_ 0 enumber eNumber� �^�]�
�^ 
erob�] 0 efrom eFrom� �\�[�Z
�\ 
errt�[ 
0 eto eTo�Z  �b �a 
0 _error  �� � ���,b  ��l+ k+ E�O*��l+ E�O��k+ E�O��  I�j+ j+ 	�&E�O��,j  �E�Y 	��%�%E�O)�a a �a a �j+ %a %�%a %Y hO�a &W X  *a ����a + _ �Yk�X�W���V
�Y .Dat:ReDanull��� ��� WebC�X {�U�T�S�U  0 dateproperties dateProperties�T  �S  �W  � �R�Q�P�O�N�M�L�R  0 dateproperties dateProperties�Q 0 newdate newDate�P 0 rec  �O 0 etext eText�N 0 enumber eNumber�M 0 efrom eFrom�L 
0 eto eTo� &��K�J�I�H�G�F�E�D�C�B�A�@�?��>�=�<�;�:��9�	�8�7�6�5�4<o������3�2�K &0 asrecordparameter asRecordParameter
�J 
year�I�
�H 
mnth
�G 
day 
�F 
hour
�E 
min 
�D 
scnd
�C 
time
�B 
msng�A 
�@ 
long�? 0 etext eText� �1�0�/
�1 
errn�0�\�/  
�> 
errn�=�Y
�< 
erob
�; 
errt�: 
�9 
enum
�8 
kocl
�7 
nmbr
�6 .corecnte****       ****
�5 
ctxt
�4 
bool� �.�-�
�. 
errn�- 0 enumber eNumber� �,�+�
�, 
erob�+ 0 efrom eFrom� �*�)�(
�* 
errt�) 
0 eto eTo�(  �3 �2 
0 _error  �V�b  EQ�Ob  ��l+ ���k�k�j�j�j���%E�O ��,�&��,FW  X  )�a a ��,a �a a �%Ob  ��,kv ��,��,FY 4 ��,�&��,FW %X  )�a a ��,a a �lva a �%O ��,�&��,FW  X  )�a a ��,a �a a �%O��,kva a l j 	 ��,kva a l j a &	 b  ��,kva & !)�a a ��,a a �lva a Y hO��,�  � �Ƣ�,�& E�W  X  )�a a ��,a �a a �%O �Ǣ�,�& E�W  X  )�a a ��,a �a a �%O ���,�&E�W  X  )�a a ��,a �a a  �%Y / ��,�&��,FW  X  )�a a ��,a �a a !�%O�W X  "*a #����a $+ %` �'��&�%���$
�' .Dat:DaRenull��� ��� ldt �& {�#�"�!�# 0 thedate theDate�"  
�! 
msng�%  � � �����  0 thedate theDate� 0 etext eText� 0 enumber eNumber� 0 efrom eFrom� 
0 eto eTo� ���������������E��
� 
msng� "0 asdateparameter asDateParameter
� 
year
� 
mnth
� 
long
� 
day 
� 
hour
� 
time�
� 
min � <
� 
scnd� � 0 etext eText� ��
�
� 
errn�
 0 enumber eNumber� �	��
�	 
erob� 0 efrom eFrom� ���
� 
errt� 
0 eto eTo�  � � 
0 _error  �$ _ J��  b  E�Y b  ��l+ E�O��,E��,�&��,E��,�"��,�"�#��,�#�W X  *a ����a + ascr  ��ޭ