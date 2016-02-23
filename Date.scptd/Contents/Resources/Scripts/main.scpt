FasdUAS 1.101.10   ��   ��    k             l      ��  ��   �� Date -- make, parse, and format dates and date strings

Notes:

- `join date` and `parse date` provide robust alternatives to `date TEXT` specifier for constructing date objects, (`date dateString` has serious portability and usability problems as it requires a precisely formatted *localized* date string): `join date` takes a record of numeric year/month/day/etc values, `parse date` takes a fixed format (ISO8601) by default


Caution:

- AppleScript's date objects are mutable(!), so any time a new date object is needed, either construct it from scratch using ASOC's `(NSDate's date...()) as date`, Standard Additions' `current date` command, or `copy _defaultDate to newDate` and work on the *copy*. NEVER use, modify, or return _defaultDate (or any other retained date object) directly, as allowing a shared mutable object to escape from this library and run loose around users' programs is a guaranteed recipe for chaos and disaster. (It's bad enough when lists and records do this, but dates don't look like mutable collections so users are even less likely to realize they contain shareable state.)


TO DO: 

- `timezone info [for tzName]` that returns record of tzName, tzAbbreviation, secondsToGMT, and daylight savings (isDST and secondsToDST, nextDSTransition)? what about localized name?

- should `join date` implement optional `with/without rollover allowed` parameter to determine if out-of-range values should be allowed to rollover or not (default: error if rollover detected) check for any out-of-range properties, as AS will silently roll over (Q. what about leap-seconds?) TBH, probably be simpler and safer to range-check year+month+hours+minutes (all those ranges are fixed, so as long as the rec's properties are anywhere within those ranges they're ok), and comparison-check the day (allowing some flexibility in the event that a leap second nudges it over to the next day), and finally check the seconds isn't obviously invalid (e.g. -1, 70)

- any value in having `seconds from GMT to tzName` convenience command? (this'd be same as `seconds to GMT` except it returns -ve value; e.g. `seconds from GMT to "America/New_York"`-> +5 hours)

- what about parsing/formatting time text as no. of seconds since midnight?

     � 	 	�   D a t e   - -   m a k e ,   p a r s e ,   a n d   f o r m a t   d a t e s   a n d   d a t e   s t r i n g s 
 
 N o t e s : 
 
 -   ` j o i n   d a t e `   a n d   ` p a r s e   d a t e `   p r o v i d e   r o b u s t   a l t e r n a t i v e s   t o   ` d a t e   T E X T `   s p e c i f i e r   f o r   c o n s t r u c t i n g   d a t e   o b j e c t s ,   ( ` d a t e   d a t e S t r i n g `   h a s   s e r i o u s   p o r t a b i l i t y   a n d   u s a b i l i t y   p r o b l e m s   a s   i t   r e q u i r e s   a   p r e c i s e l y   f o r m a t t e d   * l o c a l i z e d *   d a t e   s t r i n g ) :   ` j o i n   d a t e `   t a k e s   a   r e c o r d   o f   n u m e r i c   y e a r / m o n t h / d a y / e t c   v a l u e s ,   ` p a r s e   d a t e `   t a k e s   a   f i x e d   f o r m a t   ( I S O 8 6 0 1 )   b y   d e f a u l t 
 
 
 C a u t i o n : 
 
 -   A p p l e S c r i p t ' s   d a t e   o b j e c t s   a r e   m u t a b l e ( ! ) ,   s o   a n y   t i m e   a   n e w   d a t e   o b j e c t   i s   n e e d e d ,   e i t h e r   c o n s t r u c t   i t   f r o m   s c r a t c h   u s i n g   A S O C ' s   ` ( N S D a t e ' s   d a t e . . . ( ) )   a s   d a t e ` ,   S t a n d a r d   A d d i t i o n s '   ` c u r r e n t   d a t e `   c o m m a n d ,   o r   ` c o p y   _ d e f a u l t D a t e   t o   n e w D a t e `   a n d   w o r k   o n   t h e   * c o p y * .   N E V E R   u s e ,   m o d i f y ,   o r   r e t u r n   _ d e f a u l t D a t e   ( o r   a n y   o t h e r   r e t a i n e d   d a t e   o b j e c t )   d i r e c t l y ,   a s   a l l o w i n g   a   s h a r e d   m u t a b l e   o b j e c t   t o   e s c a p e   f r o m   t h i s   l i b r a r y   a n d   r u n   l o o s e   a r o u n d   u s e r s '   p r o g r a m s   i s   a   g u a r a n t e e d   r e c i p e   f o r   c h a o s   a n d   d i s a s t e r .   ( I t ' s   b a d   e n o u g h   w h e n   l i s t s   a n d   r e c o r d s   d o   t h i s ,   b u t   d a t e s   d o n ' t   l o o k   l i k e   m u t a b l e   c o l l e c t i o n s   s o   u s e r s   a r e   e v e n   l e s s   l i k e l y   t o   r e a l i z e   t h e y   c o n t a i n   s h a r e a b l e   s t a t e . ) 
 
 
 T O   D O :   
 
 -   ` t i m e z o n e   i n f o   [ f o r   t z N a m e ] `   t h a t   r e t u r n s   r e c o r d   o f   t z N a m e ,   t z A b b r e v i a t i o n ,   s e c o n d s T o G M T ,   a n d   d a y l i g h t   s a v i n g s   ( i s D S T   a n d   s e c o n d s T o D S T ,   n e x t D S T r a n s i t i o n ) ?   w h a t   a b o u t   l o c a l i z e d   n a m e ?  
 
 -   s h o u l d   ` j o i n   d a t e `   i m p l e m e n t   o p t i o n a l   ` w i t h / w i t h o u t   r o l l o v e r   a l l o w e d `   p a r a m e t e r   t o   d e t e r m i n e   i f   o u t - o f - r a n g e   v a l u e s   s h o u l d   b e   a l l o w e d   t o   r o l l o v e r   o r   n o t   ( d e f a u l t :   e r r o r   i f   r o l l o v e r   d e t e c t e d )   c h e c k   f o r   a n y   o u t - o f - r a n g e   p r o p e r t i e s ,   a s   A S   w i l l   s i l e n t l y   r o l l   o v e r   ( Q .   w h a t   a b o u t   l e a p - s e c o n d s ? )   T B H ,   p r o b a b l y   b e   s i m p l e r   a n d   s a f e r   t o   r a n g e - c h e c k   y e a r + m o n t h + h o u r s + m i n u t e s   ( a l l   t h o s e   r a n g e s   a r e   f i x e d ,   s o   a s   l o n g   a s   t h e   r e c ' s   p r o p e r t i e s   a r e   a n y w h e r e   w i t h i n   t h o s e   r a n g e s   t h e y ' r e   o k ) ,   a n d   c o m p a r i s o n - c h e c k   t h e   d a y   ( a l l o w i n g   s o m e   f l e x i b i l i t y   i n   t h e   e v e n t   t h a t   a   l e a p   s e c o n d   n u d g e s   i t   o v e r   t o   t h e   n e x t   d a y ) ,   a n d   f i n a l l y   c h e c k   t h e   s e c o n d s   i s n ' t   o b v i o u s l y   i n v a l i d   ( e . g .   - 1 ,   7 0 ) 
 
 -   a n y   v a l u e   i n   h a v i n g   ` s e c o n d s   f r o m   G M T   t o   t z N a m e `   c o n v e n i e n c e   c o m m a n d ?   ( t h i s ' d   b e   s a m e   a s   ` s e c o n d s   t o   G M T `   e x c e p t   i t   r e t u r n s   - v e   v a l u e ;   e . g .   ` s e c o n d s   f r o m   G M T   t o   " A m e r i c a / N e w _ Y o r k " ` - >   + 5   h o u r s ) 
 
 -   w h a t   a b o u t   p a r s i n g / f o r m a t t i n g   t i m e   t e x t   a s   n o .   o f   s e c o n d s   s i n c e   m i d n i g h t ? 
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
cobj � o     �~�~ 0 	_weekdays   �   ditto    � � � �    d i t t o �  � � � l     �}�|�{�}  �|  �{   �  � � � l     �z�y�x�z  �y  �x   �  � � � l     �w � ��w   � J D--------------------------------------------------------------------    � � � � � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - �  � � � l     �v � ��v   �   dates    � � � �    d a t e s �  � � � l     �u�t�s�u  �t  �s   �  � � � i  p s � � � I      �r ��q�r 00 _asnstimezoneparameter _asNSTimeZoneParameter �    o      �p�p 0 timezone timeZone �o o      �n�n 0 parametername parameterName�o  �q   � Z     _�m =      l    	�l�k I    	�j	

�j .corecnte****       ****	 J      �i o     �h�h 0 timezone timeZone�i  
 �g�f
�g 
kocl m    �e
�e 
nmbr�f  �l  �k   m   	 
�d�d  k    %  r     n    I    �c�b�c (0 asintegerparameter asIntegerParameter  o    �a�a 0 timezone timeZone �` m     �  t i m e   z o n e�`  �b   o    �_�_ 0 _support   o      �^�^ 0 timezone timeZone �] L    % n   $ I    $�\�[�\ 80 timezoneforsecondsfromgmt_ timeZoneForSecondsFromGMT_  �Z  o     �Y�Y 0 timezone timeZone�Z  �[   n   !"! o    �X�X 0 
nstimezone 
NSTimeZone" m    �W
�W misccura�]  �m   k   ( _## $%$ r   ( 5&'& n  ( 3()( I   - 3�V*�U�V "0 astextparameter asTextParameter* +,+ o   - .�T�T 0 timezone timeZone, -�S- o   . /�R�R 0 parametername parameterName�S  �U  ) o   ( -�Q�Q 0 _support  ' o      �P�P 0 timezone timeZone% ./. r   6 @010 n  6 >232 I   9 >�O4�N�O &0 timezonewithname_ timeZoneWithName_4 5�M5 o   9 :�L�L 0 timezone timeZone�M  �N  3 n  6 9676 o   7 9�K�K 0 
nstimezone 
NSTimeZone7 m   6 7�J
�J misccura1 o      �I�I 0 asoctimezone asocTimeZone/ 898 Z  A \:;�H�G: =  A D<=< o   A B�F�F 0 asoctimezone asocTimeZone= m   B C�E
�E 
msng; n  G X>?> I   L X�D@�C�D .0 throwinvalidparameter throwInvalidParameter@ ABA o   L M�B�B 0 timezone timeZoneB CDC o   M N�A�A 0 parametername parameterNameD EFE m   N O�@
�@ 
ctxtF G�?G b   O THIH b   O RJKJ m   O PLL �MM ( u n k n o w n   t i m e   z o n e :   K o   P Q�>�> 0 timezone timeZoneI m   R SNN �OO     n a m e�?  �C  ? o   G L�=�= 0 _support  �H  �G  9 P�<P L   ] _QQ o   ] ^�;�; 0 asoctimezone asocTimeZone�<   � RSR l     �:�9�8�:  �9  �8  S TUT l     �7�6�5�7  �6  �5  U VWV i  t wXYX I      �4Z�3�4 0 
_datestyle 
_dateStyleZ [\[ o      �2�2 0 	theformat 	theFormat\ ]�1] o      �0�0 0 formatstyles formatStyles�1  �3  Y Z     �^_`a^ =    bcb o     �/�/ 0 	theformat 	theFormatc m    �.
�. FDStFDS1_ L    dd J    ee fgf m    �-
�- boovtrueg h�,h n   iji o    
�+�+ 60 nsdateformattershortstyle NSDateFormatterShortStylej m    �*
�* misccura�,  ` klk =   mnm o    �)�) 0 	theformat 	theFormatn m    �(
�( FDStFDS2l opo L    qq J    rr sts m    �'
�' boovtruet u�&u n   vwv o    �%�% 80 nsdateformattermediumstyle NSDateFormatterMediumStylew m    �$
�$ misccura�&  p xyx =  " %z{z o   " #�#�# 0 	theformat 	theFormat{ m   # $�"
�" FDStFDS3y |}| L   ( 0~~ J   ( / ��� m   ( )�!
�! boovtrue� �� � n  ) -��� o   * ,�� 40 nsdateformatterlongstyle NSDateFormatterLongStyle� m   ) *�
� misccura�   } ��� =  3 6��� o   3 4�� 0 	theformat 	theFormat� m   4 5�
� FDStFDS4� ��� L   9 A�� J   9 @�� ��� m   9 :�
� boovtrue� ��� n  : >��� o   ; =�� 40 nsdateformatterfullstyle NSDateFormatterFullStyle� m   : ;�
� misccura�  � ��� =  D G��� o   D E�� 0 	theformat 	theFormat� m   E F�
� FDStFDS6� ��� L   J R�� J   J Q�� ��� m   J K�
� boovfals� ��� n  K O��� o   L N�� 60 nsdateformattershortstyle NSDateFormatterShortStyle� m   K L�
� misccura�  � ��� =  U X��� o   U V�� 0 	theformat 	theFormat� m   V W�
� FDStFDS7� ��� L   [ c�� J   [ b�� ��� m   [ \�
� boovfals� ��� n  \ `��� o   ] _�� 80 nsdateformattermediumstyle NSDateFormatterMediumStyle� m   \ ]�
� misccura�  � ��� =  f i��� o   f g�� 0 	theformat 	theFormat� m   g h�

�
 FDStFDS8� ��� L   l t�� J   l s�� ��� m   l m�	
�	 boovfals� ��� n  m q��� o   n p�� 40 nsdateformatterlongstyle NSDateFormatterLongStyle� m   m n�
� misccura�  � ��� =  w z��� o   w x�� 0 	theformat 	theFormat� m   x y�
� FDStFDS9� ��� L   } ��� J   } ��� ��� m   } ~�
� boovfals� ��� n  ~ ���� o    �� �  40 nsdateformatterfullstyle NSDateFormatterFullStyle� m   ~ ��
�� misccura�  �  a R   � �����
�� .ascrerr ****      � ****� m   � ��� ��� h I n v a l i d    u s i n g    p a r a m e t e r   ( n o t   a n   a l l o w e d   c o n s t a n t ) .� ����
�� 
errn� m   � ������Y� ����
�� 
erob� o   � ����� 0 formatstyles formatStyles� �����
�� 
errt� m   � ���
�� 
enum��  W ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� i  x {��� I      ������� (0 _makedateformatter _makeDateFormatter� ��� o      ���� 0 	theformat 	theFormat� ��� o      ���� 0 
localecode 
localeCode� ���� o      ���� 0 timezone timeZone��  ��  � k    E�� ��� r     ��� n    ��� I    �������� 0 init  ��  ��  � n    ��� I    �������� 	0 alloc  ��  ��  � n    ��� o    ���� "0 nsdateformatter NSDateFormatter� m     ��
�� misccura� o      ���� 0 asocformatter asocFormatter� ��� Z   ������ =    ��� l   ������ I   ����
�� .corecnte****       ****� J    �� ���� o    ���� 0 	theformat 	theFormat��  � �����
�� 
kocl� m    ��
�� 
ctxt��  ��  ��  � m    ���� � l   ,���� n   ,��� I    ,�������  0 setdateformat_ setDateFormat_� ���� l   (������ n   (��� I   " (������� "0 astextparameter asTextParameter� � � o   " #���� 0 	theformat 	theFormat  �� m   # $ � 
 u s i n g��  ��  � o    "���� 0 _support  ��  ��  ��  ��  � o    ���� 0 asocformatter asocFormatter�   use custom format string   � � 2   u s e   c u s t o m   f o r m a t   s t r i n g��  � l  / k   / 	
	 r   / ; n  / 9 I   4 9������ "0 aslistparameter asListParameter �� o   4 5���� 0 	theformat 	theFormat��  ��   o   / 4���� 0 _support   o      ���� 0 formattypes formatTypes
  Z   < ^���� =  < A o   < =���� 0 formattypes formatTypes J   = @ �� m   = >��
�� FDStFDS0��   l  D Z k   D Z  n  D J  I   E J��!����  0 setdateformat_ setDateFormat_! "��" m   E F## �$$ 4 y y y y - M M - d d ' T ' H H : m m : s s Z Z Z Z Z��  ��    o   D E���� 0 asocformatter asocFormatter %&% n  K W'(' I   L W��)���� 0 
setlocale_ 
setLocale_) *��* l  L S+����+ n  L S,-, I   O S�������� 0 systemlocale systemLocale��  ��  - n  L O./. o   M O���� 0 nslocale NSLocale/ m   L M��
�� misccura��  ��  ��  ��  ( o   K L���� 0 asocformatter asocFormatter& 0��0 L   X Z11 o   X Y���� 0 asocformatter asocFormatter��     return ISO8601 formatter    �22 2   r e t u r n   I S O 8 6 0 1   f o r m a t t e r��  ��   343 n  _ i565 I   ` i��7���� 0 setdatestyle_ setDateStyle_7 8��8 l  ` e9����9 n  ` e:;: o   a e���� 00 nsdateformatternostyle NSDateFormatterNoStyle; m   ` a��
�� misccura��  ��  ��  ��  6 o   _ `���� 0 asocformatter asocFormatter4 <=< n  j t>?> I   k t��@���� 0 settimestyle_ setTimeStyle_@ A��A l  k pB����B n  k pCDC o   l p���� 00 nsdateformatternostyle NSDateFormatterNoStyleD m   k l��
�� misccura��  ��  ��  ��  ? o   j k���� 0 asocformatter asocFormatter= EFE r   u �GHG J   u yII JKJ m   u v��
�� boovfalsK L��L m   v w��
�� boovfals��  H J      MM NON o      ���� 0 	isdateset 	isDateSetO P��P o      ���� 0 	istimeset 	isTimeSet��  F Q��Q X   �R��SR k   �TT UVU r   � �WXW I      ��Y���� 0 
_datestyle 
_dateStyleY Z[Z n  � �\]\ 1   � ���
�� 
pcnt] o   � ����� 0 aref aRef[ ^��^ o   � ����� 0 	theformat 	theFormat��  ��  X J      __ `a` o      ���� 0 isdate isDatea b��b o      ���� 0 
asocoption 
asocOption��  V c��c Z   �de��fd o   � ����� 0 isdate isDatee k   � �gg hih Z  � �jk����j o   � ����� 0 	isdateset 	isDateSetk R   � ���lm
�� .ascrerr ****      � ****l m   � �nn �oo d I n v a l i d    u s i n g    p a r a m e t e r   ( t o o   m a n y   d a t e   f o r m a t s ) .m ��pq
�� 
errnp m   � ������Yq ��r��
�� 
erobr o   � ����� 0 formattypes formatTypes��  ��  ��  i sts l  � �u����u n  � �vwv I   � ���x���� 0 setdatestyle_ setDateStyle_x y�y o   � ��~�~ 0 
asocoption 
asocOption�  ��  w o   � ��}�} 0 asocformatter asocFormatter��  ��  t z�|z r   � �{|{ m   � ��{
�{ boovtrue| o      �z�z 0 	isdateset 	isDateSet�|  ��  f k   �}} ~~ Z  ����y�x� o   � ��w�w 0 	istimeset 	isTimeSet� R   � �v��
�v .ascrerr ****      � ****� m   � ��� ��� d I n v a l i d    u s i n g    p a r a m e t e r   ( t o o   m a n y   t i m e   f o r m a t s ) .� �u��
�u 
errn� m   � ��t�t�Y� �s��r
�s 
erob� o   � ��q�q 0 formattypes formatTypes�r  �y  �x   ��� l ��p�o� n ��� I  �n��m�n 0 settimestyle_ setTimeStyle_� ��l� o  �k�k 0 
asocoption 
asocOption�l  �m  � o  �j�j 0 asocformatter asocFormatter�p  �o  � ��i� r  ��� m  �h
�h boovtrue� o      �g�g 0 	istimeset 	isTimeSet�i  ��  �� 0 aref aRefS o   � ��f�f 0 formattypes formatTypes��   < 6 use predefined date-style and/or time-style constants    ��� l   u s e   p r e d e f i n e d   d a t e - s t y l e   a n d / o r   t i m e - s t y l e   c o n s t a n t s� ��� n '��� I  '�e��d�e 0 
setlocale_ 
setLocale_� ��c� l #��b�a� n #��� I  #�`��_�` *0 asnslocaleparameter asNSLocaleParameter� ��� o  �^�^ 0 
localecode 
localeCode� ��]� m  �� ���  f o r   l o c a l e�]  �_  � o  �\�\ 0 _support  �b  �a  �c  �d  � o  �[�[ 0 asocformatter asocFormatter� ��� Z (B���Z�Y� > (-��� o  ()�X�X 0 timezone timeZone� m  ),�W
�W 
msng� n 0>��� I  1>�V��U�V 0 settimezone_ setTimeZone_� ��T� l 1:��S�R� I  1:�Q��P�Q 00 _asnstimezoneparameter _asNSTimeZoneParameter� ��� o  23�O�O 0 timezone timeZone� ��N� m  36�� ���  t i m e   z o n e�N  �P  �S  �R  �T  �U  � o  01�M�M 0 asocformatter asocFormatter�Z  �Y  � ��L� L  CE�� o  CD�K�K 0 asocformatter asocFormatter�L  � ��� l     �J�I�H�J  �I  �H  � ��� l     �G�F�E�G  �F  �E  � ��� l     �D�C�B�D  �C  �B  � ��� i  | ��� I     �A��
�A .Dat:FDatnull���     ldt � o      �@�@ 0 thedate theDate� �?��
�? 
Usin� |�>�=��<��>  �=  � o      �;�; 0 	theformat 	theFormat�<  � l     ��:�9� J      �� ��8� m      �7
�7 FDStFDS0�8  �:  �9  � �6��
�6 
Loca� |�5�4��3��5  �4  � o      �2�2 0 
localecode 
localeCode�3  � l     ��1�0� m      �/
�/ LclELclS�1  �0  � �.��-
�. 
TZon� |�,�+��*��,  �+  � o      �)�) 0 timezone timeZone�*  � l     ��(�'� m      �&
�& 
msng�(  �'  �-  � Q     7���� k    %�� ��� r    ��� n   ��� I    �%��$�% "0 asdateparameter asDateParameter� ��� o    	�#�# 0 thedate theDate� ��"� m   	 
�� ���  �"  �$  � o    �!�! 0 _support  � o      � �  0 thedate theDate� ��� r    ��� I    ���� (0 _makedateformatter _makeDateFormatter� ��� o    �� 0 	theformat 	theFormat� ��� o    �� 0 
localecode 
localeCode� ��� o    �� 0 timezone timeZone�  �  � o      �� 0 asocformatter asocFormatter� ��� L    %�� c    $��� l   "���� n   "��� I    "���� "0 stringfromdate_ stringFromDate_� ��� o    �� 0 thedate theDate�  �  � o    �� 0 asocformatter asocFormatter�  �  � m   " #�
� 
ctxt�  � R      ���
� .ascrerr ****      � ****� o      �� 0 etext eText� ���
� 
errn� o      �� 0 enumber eNumber� ���
� 
erob� o      �
�
 0 efrom eFrom� �	��
�	 
errt� o      �� 
0 eto eTo�  � I   - 7���� 
0 _error  � ��� m   . /�� �    f o r m a t   d a t e�  o   / 0�� 0 etext eText  o   0 1�� 0 enumber eNumber  o   1 2�� 0 efrom eFrom � o   2 3� �  
0 eto eTo�  �  � 	 l     ��������  ��  ��  	 

 l     ��������  ��  ��    i  � � I     ��
�� .Dat:PDatnull���     ctxt o      ���� 0 thetext theText ��
�� 
Usin |��������  ��   o      ���� 0 	theformat 	theFormat��   l     ���� J       �� m      ��
�� FDStFDS0��  ��  ��   ��
�� 
Loca |��������  ��   o      ���� 0 
localecode 
localeCode��   l     ���� m      ��
�� LclELclS��  ��   ����
�� 
TZon |������ ��  ��   o      ���� 0 timezone timeZone��    l     !����! m      ��
�� 
msng��  ��  ��   l    �"#$" Q     �%&'% k    �(( )*) r    +,+ n   -.- I    ��/���� &0 stringwithstring_ stringWithString_/ 0��0 l   1����1 n   232 I    ��4���� "0 astextparameter asTextParameter4 565 o    ���� 0 thetext theText6 7��7 m    88 �99  ��  ��  3 o    ���� 0 _support  ��  ��  ��  ��  . n   :;: o    ���� 0 nsstring NSString; m    ��
�� misccura, o      ���� 0 asoctext asocText* <=< r    ">?> I     ��@���� (0 _makedateformatter _makeDateFormatter@ ABA o    ���� 0 	theformat 	theFormatB CDC o    ���� 0 
localecode 
localeCodeD E��E o    ���� 0 timezone timeZone��  ��  ? o      ���� 0 asocformatter asocFormatter= FGF r   # +HIH n  # )JKJ I   $ )��L���� "0 datefromstring_ dateFromString_L M��M o   $ %���� 0 thetext theText��  ��  K o   # $���� 0 asocformatter asocFormatterI o      ���� 0 asocdate asocDateG NON Z   , �PQ����P =  , /RSR o   , -���� 0 asocdate asocDateS m   - .��
�� 
msngQ l  2 �TUVT k   2 �WW XYX r   2 =Z[Z n  2 ;\]\ I   7 ;�������� $0 localeidentifier localeIdentifier��  ��  ] n  2 7^_^ I   3 7�������� 
0 locale  ��  ��  _ o   2 3���� 0 asocformatter asocFormatter[ o      ���� $0 localeidentifier localeIdentifierY `a` Z   > ]bc��db G   > Mefe =  > Aghg o   > ?���� $0 localeidentifier localeIdentifierh m   ? @��
�� 
msngf =   D Kiji n  D Iklk 1   G I��
�� 
lengl l  D Gm����m c   D Gnon o   D E���� $0 localeidentifier localeIdentifiero m   E F��
�� 
ctxt��  ��  j m   I J����  c r   P Spqp m   P Qrr �ss  s t a n d a r dq o      ���� $0 localeidentifier localeIdentifier��  d r   V ]tut b   V [vwv b   V Yxyx m   V Wzz �{{  y o   W X���� $0 localeidentifier localeIdentifierw m   Y Z|| �}}  u o      ���� $0 localeidentifier localeIdentifiera ~��~ R   ^ ����
�� .ascrerr ****      � **** l  l ������ b   l ��� b   l {��� b   l y��� b   l u��� m   l o�� ��� t T e x t   i s   n o t   i n   t h e   c o r r e c t   f o r m a t   ( e x p e c t e d   d a t e   t e x t   i n   � l  o t������ n  o t��� I   p t�������� 0 
dateformat 
dateFormat��  ��  � o   o p���� 0 asocformatter asocFormatter��  ��  � m   u x�� ��� "    f o r m a t   f o r   t h e  � o   y z���� $0 localeidentifier localeIdentifier� m   { ~�� ���    l o c a l e . )��  ��  � ����
�� 
errn� m   b e�����Y� �����
�� 
erob� o   h i���� 0 thetext theText��  ��  U &   parsing failed, so report error   V ��� @   p a r s i n g   f a i l e d ,   s o   r e p o r t   e r r o r��  ��  O ���� l  � ����� L   � ��� c   � ���� o   � ����� 0 asocdate asocDate� m   � ���
�� 
ldt � � � note that AS dates don't include time zone info, so resulting date object always uses host machine's current tz, regardless of what tz theText used, adjusting the date object's time appropriately   � ����   n o t e   t h a t   A S   d a t e s   d o n ' t   i n c l u d e   t i m e   z o n e   i n f o ,   s o   r e s u l t i n g   d a t e   o b j e c t   a l w a y s   u s e s   h o s t   m a c h i n e ' s   c u r r e n t   t z ,   r e g a r d l e s s   o f   w h a t   t z   t h e T e x t   u s e d ,   a d j u s t i n g   t h e   d a t e   o b j e c t ' s   t i m e   a p p r o p r i a t e l y��  & R      ����
�� .ascrerr ****      � ****� o      ���� 0 etext eText� ����
�� 
errn� o      ���� 0 enumber eNumber� ����
�� 
erob� o      ���� 0 efrom eFrom� �����
�� 
errt� o      ���� 
0 eto eTo��  ' I   � �������� 
0 _error  � ��� m   � ��� ���  p a r s e   d a t e� ��� o   � ����� 0 etext eText� ��� o   � ����� 0 enumber eNumber� ��� o   � ����� 0 efrom eFrom� ���� o   � ����� 
0 eto eTo��  ��  # N H note that `time zone` param is ignored when TZ is provided by date text   $ ��� �   n o t e   t h a t   ` t i m e   z o n e `   p a r a m   i s   i g n o r e d   w h e n   T Z   i s   p r o v i d e d   b y   d a t e   t e x t ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� l     ������  � J D--------------------------------------------------------------------   � ��� � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -� ��� l     ������  �   Date creation   � ���    D a t e   c r e a t i o n� ��� l     ����~��  �  �~  � ��� l     �}�|�{�}  �|  �{  � ��� i  � ���� I     �z��y
�z .Dat:ReDanull��� ��� WebC� |�x�w��v��x  �w  � o      �u�u  0 dateproperties dateProperties�v  � l     ��t�s� J      �r�r  �t  �s  �y  � Q    ���� k   ��� ��� s    ��� o    �q�q 0 _defaultdate _defaultDate� o      �p�p 0 newdate newDate� ��� l   *���� r    *��� l   (��o�n� b    (��� n   ��� I    �m��l�m &0 asrecordparameter asRecordParameter� ��� o    �k�k  0 dateproperties dateProperties� ��j� m    �� ���  �j  �l  � o    �i�i 0 _support  � K    '�� �h��
�h 
year� m    �g�g�� �f��
�f 
mnth� m    �e�e � �d��
�d 
day � m    �c�c � �b��
�b 
hour� m    �a�a  � �`��
�` 
min � m     !�_�_  � �^��
�^ 
scnd� m   " #�]�]  � �\��[
�\ 
time� m   $ %�Z
�Z 
msng�[  �o  �n  � o      �Y�Y 0 rec  � @ : use the Cocoa epoch (1 January 2001, 00:00:00) as default   � ��� t   u s e   t h e   C o c o a   e p o c h   ( 1   J a n u a r y   2 0 0 1 ,   0 0 : 0 0 : 0 0 )   a s   d e f a u l t� ��� Q   + X���� r   . 7��� c   . 3��� n  . 1� � 1   / 1�X
�X 
year  o   . /�W�W 0 rec  � m   1 2�V
�V 
long� n      1   4 6�U
�U 
year o   3 4�T�T 0 newdate newDate� R      �S
�S .ascrerr ****      � **** o      �R�R 0 etext eText �Q�P
�Q 
errn d       m      �O�O��P  � R   ? X�N
�N .ascrerr ****      � **** b   R W	
	 m   R U � 2 I n v a l i d    y e a r    p r o p e r t y :  
 o   U V�M�M 0 etext eText �L
�L 
errn m   A D�K�K�Y �J
�J 
erob l  G K�I�H N   G K n   G J 1   H J�G
�G 
year o   G H�F�F  0 dateproperties dateProperties�I  �H   �E�D
�E 
errt m   N O�C
�C 
long�D  �  Z   Y ��B E  Y d o   Y ^�A�A 0 _months   J   ^ c �@ n  ^ a  m   _ a�?
�? 
mnth  o   ^ _�>�> 0 rec  �@   l  g n!"#! r   g n$%$ n  g j&'& m   h j�=
�= 
mnth' o   g h�<�< 0 rec  % n     ()( m   k m�;
�; 
mnth) o   j k�:�: 0 newdate newDate" unlike year/day/time properties, which require numbers, a date object's `month` property accepts either an integer or a month constant; however, it also happily accepts weekday constants which is obviously wrong, so make sure a given constant is a valid month before assigning it   # �**0   u n l i k e   y e a r / d a y / t i m e   p r o p e r t i e s ,   w h i c h   r e q u i r e   n u m b e r s ,   a   d a t e   o b j e c t ' s   ` m o n t h `   p r o p e r t y   a c c e p t s   e i t h e r   a n   i n t e g e r   o r   a   m o n t h   c o n s t a n t ;   h o w e v e r ,   i t   a l s o   h a p p i l y   a c c e p t s   w e e k d a y   c o n s t a n t s   w h i c h   i s   o b v i o u s l y   w r o n g ,   s o   m a k e   s u r e   a   g i v e n   c o n s t a n t   i s   a   v a l i d   m o n t h   b e f o r e   a s s i g n i n g   i t�B   l  q �+,-+ Q   q �./0. r   t }121 c   t y343 n  t w565 m   u w�9
�9 
mnth6 o   t u�8�8 0 rec  4 m   w x�7
�7 
long2 n     787 m   z |�6
�6 
mnth8 o   y z�5�5 0 newdate newDate/ R      �49:
�4 .ascrerr ****      � ****9 o      �3�3 0 etext eText: �2;�1
�2 
errn; d      << m      �0�0��1  0 R   � ��/=>
�/ .ascrerr ****      � ****= b   � �?@? m   � �AA �BB 4 I n v a l i d    m o n t h    p r o p e r t y :  @ o   � ��.�. 0 etext eText> �-CD
�- 
errnC m   � ��,�,�YD �+EF
�+ 
erobE l  � �G�*�)G N   � �HH n   � �IJI m   � ��(
�( 
mnthJ o   � ��'�'  0 dateproperties dateProperties�*  �)  F �&K�%
�& 
errtK J   � �LL MNM m   � ��$
�$ 
enumN O�#O m   � ��"
�" 
long�#  �%  , , & otherwise it must be an integer value   - �PP L   o t h e r w i s e   i t   m u s t   b e   a n   i n t e g e r   v a l u e QRQ Q   � �STUS r   � �VWV c   � �XYX n  � �Z[Z 1   � ��!
�! 
day [ o   � �� �  0 rec  Y m   � ��
� 
longW n     \]\ 1   � ��
� 
day ] o   � ��� 0 newdate newDateT R      �^_
� .ascrerr ****      � ****^ o      �� 0 etext eText_ �`�
� 
errn` d      aa m      ����  U R   � ��bc
� .ascrerr ****      � ****b b   � �ded m   � �ff �gg 0 I n v a l i d    d a y    p r o p e r t y :  e o   � ��� 0 etext eTextc �hi
� 
errnh m   � ����Yi �jk
� 
erobj l  � �l��l N   � �mm n   � �non 1   � ��
� 
day o o   � ���  0 dateproperties dateProperties�  �  k �p�
� 
errtp m   � ��
� 
long�  R qrq Z   �1st��
s F   �uvu F   � �wxw =   � �yzy l  � �{�	�{ I  � ��|}
� .corecnte****       ****| J   � �~~ � n  � ���� m   � ��
� 
mnth� o   � ��� 0 rec  �  } ���
� 
kocl� m   � ��
� 
nmbr�  �	  �  z m   � �� �   x =   � ���� l  � ������� I  � �����
�� .corecnte****       ****� J   � ��� ���� n  � ���� m   � ���
�� 
mnth� o   � ����� 0 rec  ��  � �����
�� 
kocl� m   � ���
�� 
ctxt��  ��  ��  � m   � �����  v H   �
�� E  �	��� o   ����� 0 _months  � J  �� ���� n ��� m  ��
�� 
mnth� o  ���� 0 rec  ��  t l -���� R  -����
�� .ascrerr ****      � ****� m  ),�� ��� p I n v a l i d    m o n t h    p r o p e r t y   ( e x p e c t e d   i n t e g e r   o r   c o n s t a n t ) .� ����
�� 
errn� m  �����Y� ����
�� 
erob� l ������ N  �� n  ��� m  ��
�� 
mnth� o  ����  0 dateproperties dateProperties��  ��  � �����
�� 
errt� J   &�� ��� m   #��
�� 
enum� ���� m  #$��
�� 
long��  ��  � o i TO DO: revise this: first check for constant and cast if found, then try integer cast and error if fails   � ��� �   T O   D O :   r e v i s e   t h i s :   f i r s t   c h e c k   f o r   c o n s t a n t   a n d   c a s t   i f   f o u n d ,   t h e n   t r y   i n t e g e r   c a s t   a n d   e r r o r   i f   f a i l s�  �
  r ��� Z  2������� = 27��� n 25��� 1  35��
�� 
time� o  23���� 0 rec  � m  56��
�� 
msng� k  :��� ��� Q  :i���� r  =H��� [  =F��� o  =>���� 0 newdate newDate� ]  >E��� l >?������ 1  >?��
�� 
hour��  ��  � l ?D������ c  ?D��� n ?B��� 1  @B��
�� 
hour� o  ?@���� 0 rec  � m  BC��
�� 
long��  ��  � o      ���� 0 newdate newDate� R      ����
�� .ascrerr ****      � ****� o      ���� 0 etext eText� �����
�� 
errn� d      �� m      �������  � R  Pi����
�� .ascrerr ****      � ****� b  ch��� m  cf�� ��� 4 I n v a l i d    h o u r s    p r o p e r t y :  � o  fg���� 0 etext eText� ����
�� 
errn� m  RU�����Y� ����
�� 
erob� l X\������ N  X\�� n  X[��� 1  Y[��
�� 
hour� o  XY����  0 dateproperties dateProperties��  ��  � �����
�� 
errt� m  _`��
�� 
long��  � ��� Q  j����� r  mx��� [  mv��� o  mn���� 0 newdate newDate� ]  nu��� l no������ 1  no��
�� 
min ��  ��  � l ot������ c  ot��� n or��� 1  pr��
�� 
min � o  op���� 0 rec  � m  rs��
�� 
long��  ��  � o      ���� 0 newdate newDate� R      ����
�� .ascrerr ****      � ****� o      ���� 0 etext eText� �����
�� 
errn� d      �� m      �������  � R  ������
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
long��  � ���� Q  ������ r  ��� � [  �� o  ������ 0 newdate newDate l ������ c  �� n �� m  ����
�� 
scnd o  ������ 0 rec   m  ����
�� 
long��  ��    o      ���� 0 newdate newDate� R      ��	
�� .ascrerr ****      � **** o      ���� 0 etext eText	 ��
��
�� 
errn
 d       m      �������  � R  ����
�� .ascrerr ****      � **** b  �� m  �� � 8 I n v a l i d    s e c o n d s    p r o p e r t y :   o  ������ 0 etext eText ��
�� 
errn m  �������Y ��
�� 
erob l ������ N  �� n  �� m  ����
�� 
scnd o  ������  0 dateproperties dateProperties��  ��   ����
�� 
errt m  ����
�� 
long��  ��  ��  � Q  �� r  �� c  �� !  n ��"#" 1  ����
�� 
time# o  ������ 0 rec  ! m  ����
�� 
long n     $%$ 1  ����
�� 
time% o  ������ 0 newdate newDate R      ��&'
�� .ascrerr ****      � ****& o      ���� 0 etext eText' ��(��
�� 
errn( d      )) m      �������   R  ����*+
�� .ascrerr ****      � ***** b  ��,-, m  ��.. �// 2 I n v a l i d    t i m e    p r o p e r t y :  - o  ������ 0 etext eText+ ��01
�� 
errn0 m  �������Y1 ��23
�� 
erob2 l ��4����4 N  ��55 n  ��676 1  ����
�� 
time7 o  ����  0 dateproperties dateProperties��  ��  3 �~8�}
�~ 
errt8 m  ���|
�| 
long�}  � 9�{9 L  ��:: o  ���z�z 0 newdate newDate�{  � R      �y;<
�y .ascrerr ****      � ****; o      �x�x 0 etext eText< �w=>
�w 
errn= o      �v�v 0 enumber eNumber> �u?@
�u 
erob? o      �t�t 0 efrom eFrom@ �sA�r
�s 
errtA o      �q�q 
0 eto eTo�r  � I  �pB�o�p 
0 _error  B CDC m  EE �FF  j o i n   d a t eD GHG o  �n�n 0 etext eTextH IJI o  �m�m 0 enumber eNumberJ KLK o  	�l�l 0 efrom eFromL M�kM o  	
�j�j 
0 eto eTo�k  �o  � NON l     �i�h�g�i  �h  �g  O PQP l     �f�e�d�f  �e  �d  Q RSR i  � �TUT I     �cV�b
�c .Dat:DaRenull��� ��� ldt V |�a�`W�_X�a  �`  W o      �^�^ 0 thedate theDate�_  X l     Y�]�\Y m      �[
�[ 
msng�]  �\  �b  U Q     ^Z[\Z k    H]] ^_^ Z     `a�Zb` =   cdc o    �Y�Y 0 thedate theDated m    �X
�X 
msnga r   	 efe o   	 �W�W 0 _defaultdate _defaultDatef o      �V�V 0 thedate theDate�Z  b r     ghg n   iji I    �Uk�T�U "0 asdateparameter asDateParameterk lml o    �S�S 0 thedate theDatem n�Rn m    oo �pp  �R  �T  j o    �Q�Q 0 _support  h o      �P�P 0 thedate theDate_ q�Oq L   ! Hrr K   ! Gss �Ntu
�N 
yeart n  " &vwv 1   # %�M
�M 
yearw o   " #�L�L 0 thedate theDateu �Kxy
�K 
mnthx c   ' ,z{z n  ' *|}| m   ( *�J
�J 
mnth} o   ' (�I�I 0 thedate theDate{ m   * +�H
�H 
longy �G~
�G 
day ~ n  - 1��� 1   . 0�F
�F 
day � o   - .�E�E 0 thedate theDate �D��
�D 
hour� _   2 7��� l  2 5��C�B� n  2 5��� 1   3 5�A
�A 
time� o   2 3�@�@ 0 thedate theDate�C  �B  � m   5 6�?�?� �>��
�> 
min � `   8 ?��� _   8 =��� l  8 ;��=�<� n  8 ;��� 1   9 ;�;
�; 
time� o   8 9�:�: 0 thedate theDate�=  �<  � m   ; <�9�9 <� m   = >�8�8 <� �7��6
�7 
scnd� `   @ E��� l  @ C��5�4� n  @ C��� 1   A C�3
�3 
time� o   @ A�2�2 0 thedate theDate�5  �4  � m   C D�1�1 <�6  �O  [ R      �0��
�0 .ascrerr ****      � ****� o      �/�/ 0 etext eText� �.��
�. 
errn� o      �-�- 0 enumber eNumber� �,��
�, 
erob� o      �+�+ 0 efrom eFrom� �*��)
�* 
errt� o      �(�( 
0 eto eTo�)  \ I   P ^�'��&�' 
0 _error  � ��� m   Q T�� ���  s p l i t   d a t e� ��� o   T U�%�% 0 etext eText� ��� o   U V�$�$ 0 enumber eNumber� ��� o   V W�#�# 0 efrom eFrom� ��"� o   W X�!�! 
0 eto eTo�"  �&  S ��� l     � ���   �  �  � ��� l     ����  �  �  � ��� l     ����  � J D--------------------------------------------------------------------   � ��� � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -� ��� l     ����  �   time zone support   � ��� $   t i m e   z o n e   s u p p o r t� ��� l     ����  �  �  � ��� l     ����  �  �  � ��� i  � ���� I     ���
� .Dat:LiTznull��� ��� null�  �  � l    ���� L     �� c     ��� l    ���� n    ��� I    ���� 60 sortedarrayusingselector_ sortedArrayUsingSelector_� ��� m    �� ���  c o m p a r e :�  �  � n    ��� I    �
�	��
 (0 knowntimezonenames knownTimeZoneNames�	  �  � n    ��� o    �� 0 
nstimezone 
NSTimeZone� m     �
� misccura�  �  � m    �
� 
list� � �> {"Africa/Abidjan", "Africa/Accra", "Africa/Addis_Ababa", ...} -- what about optional parameter for specifying no of seconds from GMT? if given, list would be filtered for time zones with that offset only   � ���� >   { " A f r i c a / A b i d j a n " ,   " A f r i c a / A c c r a " ,   " A f r i c a / A d d i s _ A b a b a " ,   . . . }   - -   w h a t   a b o u t   o p t i o n a l   p a r a m e t e r   f o r   s p e c i f y i n g   n o   o f   s e c o n d s   f r o m   G M T ?   i f   g i v e n ,   l i s t   w o u l d   b e   f i l t e r e d   f o r   t i m e   z o n e s   w i t h   t h a t   o f f s e t   o n l y� ��� l     ����  �  �  � ��� l     �� ���  �   ��  � ��� i  � ���� I     ������
�� .Dat:CuTznull��� ��� null��  ��  � L     �� c     ��� l    ������ n    ��� I    �������� 0 name  ��  ��  � n    ��� I    �������� 0 localtimezone localTimeZone��  ��  � n    ��� o    ���� 0 
nstimezone 
NSTimeZone� m     ��
�� misccura��  ��  � m    ��
�� 
ctxt� ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� i  � ���� I     �����
�� .Dat:TzGMnull��� ��� null��  � �����
�� 
From� |����������  ��  � o      ���� 0 tzname tzName��  � l     ������ m      ��
�� 
msng��  ��  ��  � Q     V���� Z    @������ =   ��� o    ���� 0 tzname tzName� m    ��
�� 
msng� l  	 ���� L   	 �� n  	 ��� I    ��������  0 secondsfromgmt secondsFromGMT��  ��  � n  	    I    �������� 0 localtimezone localTimeZone��  ��   n  	  o   
 ���� 0 
nstimezone 
NSTimeZone m   	 
��
�� misccura� 6 0 equivalent to Standard Additions' `time to GMT`   � � `   e q u i v a l e n t   t o   S t a n d a r d   A d d i t i o n s '   ` t i m e   t o   G M T `��  � k    @  Z   3	���� =    #

 l   !���� I   !��
�� .corecnte****       **** J     �� o    ���� 0 tzname tzName��   ����
�� 
kocl m    ��
�� 
ctxt��  ��  ��   m   ! "����  	 I   & /������ 60 throwinvalidparametertype throwInvalidParameterType  o   ' (���� 0 tzname tzName  m   ( ) �  f r o m  m   ) * �  t e x t �� m   * +��
�� 
ctxt��  ��  ��  ��   �� L   4 @ n  4 ? !  I   ; ?��������  0 secondsfromgmt secondsFromGMT��  ��  ! I   4 ;��"���� 00 _asnstimezoneparameter _asNSTimeZoneParameter" #$# o   5 6���� 0 tzname tzName$ %��% m   6 7&& �''  ��  ��  ��  � R      ��()
�� .ascrerr ****      � ****( o      ���� 0 etext eText) ��*+
�� 
errn* o      ���� 0 enumber eNumber+ ��,-
�� 
erob, o      ���� 0 efrom eFrom- ��.��
�� 
errt. o      ���� 
0 eto eTo��  � I   H V��/���� 
0 _error  / 010 m   I L22 �33  s e c o n d s   t o   G M T1 454 o   L M���� 0 etext eText5 676 o   M N���� 0 enumber eNumber7 898 o   N O���� 0 efrom eFrom9 :��: o   O P���� 
0 eto eTo��  ��  � ;<; l     ��������  ��  ��  < =>= l     ��������  ��  ��  > ?��? l     ��������  ��  ��  ��       ��@ABCDEFGHIJKLMNOPQRS��  @ ��������������������������������������
�� 
pimr�� 0 _support  �� 
0 _error  �� $0 _makedefaultdate _makeDefaultDate�� 0 _defaultdate _defaultDate�� 0 _months  �� 0 	_weekdays  
�� .Dat:Mthsnull��� ��� null
�� .Dat:Wkdsnull��� ��� null�� 00 _asnstimezoneparameter _asNSTimeZoneParameter�� 0 
_datestyle 
_dateStyle�� (0 _makedateformatter _makeDateFormatter
�� .Dat:FDatnull���     ldt 
�� .Dat:PDatnull���     ctxt
�� .Dat:ReDanull��� ��� WebC
�� .Dat:DaRenull��� ��� ldt 
�� .Dat:LiTznull��� ��� null
�� .Dat:CuTznull��� ��� null
�� .Dat:TzGMnull��� ��� nullA ��T�� T  UVU ��W��
�� 
cobjW XX   �� 
�� 
frmk��  V ��Y��
�� 
cobjY ZZ   ��
�� 
osax��  B [[   �� +
�� 
scptC �� 3����\]���� 
0 _error  �� ��^�� ^  ������~�}�� 0 handlername handlerName�� 0 etext eText� 0 enumber eNumber�~ 0 efrom eFrom�} 
0 eto eTo��  \ �|�{�z�y�x�| 0 handlername handlerName�{ 0 etext eText�z 0 enumber eNumber�y 0 efrom eFrom�x 
0 eto eTo]  C�w�v�w �v &0 throwcommanderror throwCommandError�� b  ࠡ����+ D �u W�t�s_`�r�u $0 _makedefaultdate _makeDefaultDate�t  �s  _  ` �q�p�o�n�m�l�k
�q .misccurdldt    ��� null�p�
�o 
cobj
�n 
year
�m 
mnth
�l 
day 
�k 
time�r F*j   >�kkmvE[�k/*�,FZ[�l/*�,FZ[�m/*�,FZOkjlvE[�k/*�,FZ[�l/*�,FZO*UE ldt     �uy F �ja�j a  �i�h�g�f�e�d�c�b�a�`�_�^
�i 
jan 
�h 
feb 
�g 
mar 
�f 
apr 
�e 
may 
�d 
jun 
�c 
jul 
�b 
aug 
�a 
sep 
�` 
oct 
�_ 
nov 
�^ 
dec G �]b�] b  �\�[�Z�Y�X�W�V
�\ 
mon 
�[ 
tue 
�Z 
wed 
�Y 
thu 
�X 
fri 
�W 
sat 
�V 
sun H �U ��T�Scd�R
�U .Dat:Mthsnull��� ��� null�T  �S  c  d �Q
�Q 
cobj�R 
b  �-EI �P ��O�Nef�M
�P .Dat:Wkdsnull��� ��� null�O  �N  e  f �L
�L 
cobj�M 
b  �-EJ �K ��J�Igh�H�K 00 _asnstimezoneparameter _asNSTimeZoneParameter�J �Gi�G i  �F�E�F 0 timezone timeZone�E 0 parametername parameterName�I  g �D�C�B�D 0 timezone timeZone�C 0 parametername parameterName�B 0 asoctimezone asocTimeZoneh �A�@�?�>�=�<�;�:�9�8�7LN�6�5
�A 
kocl
�@ 
nmbr
�? .corecnte****       ****�> (0 asintegerparameter asIntegerParameter
�= misccura�< 0 
nstimezone 
NSTimeZone�; 80 timezoneforsecondsfromgmt_ timeZoneForSecondsFromGMT_�: "0 astextparameter asTextParameter�9 &0 timezonewithname_ timeZoneWithName_
�8 
msng
�7 
ctxt�6 �5 .0 throwinvalidparameter throwInvalidParameter�H `�kv��l k  b  ��l+ E�O��,�k+ Y 9b  ��l+ E�O��,�k+ 	E�O��  b  ����%�%�+ Y hO�K �4Y�3�2jk�1�4 0 
_datestyle 
_dateStyle�3 �0l�0 l  �/�.�/ 0 	theformat 	theFormat�. 0 formatstyles formatStyles�2  j �-�,�- 0 	theformat 	theFormat�, 0 formatstyles formatStylesk �+�*�)�(�'�&�%�$�#�"�!� ��������
�+ FDStFDS1
�* misccura�) 60 nsdateformattershortstyle NSDateFormatterShortStyle
�( FDStFDS2�' 80 nsdateformattermediumstyle NSDateFormatterMediumStyle
�& FDStFDS3�% 40 nsdateformatterlongstyle NSDateFormatterLongStyle
�$ FDStFDS4�# 40 nsdateformatterfullstyle NSDateFormatterFullStyle
�" FDStFDS6
�! FDStFDS7
�  FDStFDS8
� FDStFDS9
� 
errn��Y
� 
erob
� 
errt
� 
enum� �1 ���  e��,ElvY ���  e��,ElvY z��  e��,ElvY i��  e��,ElvY X��  f��,ElvY G��  f��,ElvY 6��  f��,ElvY %��  f��,ElvY )���a a a a L ����mn�� (0 _makedateformatter _makeDateFormatter� �o� o  ���� 0 	theformat 	theFormat� 0 
localecode 
localeCode� 0 timezone timeZone�  m 
�������
�	��� 0 	theformat 	theFormat� 0 
localecode 
localeCode� 0 timezone timeZone� 0 asocformatter asocFormatter� 0 formattypes formatTypes� 0 	isdateset 	isDateSet�
 0 	istimeset 	isTimeSet�	 0 aref aRef� 0 isdate isDate� 0 
asocoption 
asocOptionn "������� ��������#��������������������������n�����������
� misccura� "0 nsdateformatter NSDateFormatter� 	0 alloc  � 0 init  
� 
kocl
� 
ctxt
�  .corecnte****       ****�� "0 astextparameter asTextParameter��  0 setdateformat_ setDateFormat_�� "0 aslistparameter asListParameter
�� FDStFDS0�� 0 nslocale NSLocale�� 0 systemlocale systemLocale�� 0 
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
erob�� �� *0 asnslocaleparameter asNSLocaleParameter
�� 
msng�� 00 _asnstimezoneparameter _asNSTimeZoneParameter�� 0 settimezone_ setTimeZone_�F��,j+ j+ E�O�kv��l k  �b  ��l+ k+ 	Y �b  �k+ 
E�O��kv  ��k+ 	O���,j+ k+ O�Y hO��a ,k+ O��a ,k+ OfflvE[a k/E�Z[a l/E�ZO ��[�a l kh *�a ,�l+ E[a k/E�Z[a l/E�ZO� *� )a a a �a a Y hO��k+ OeE�Y '� )a a a �a a Y hO��k+ OeE�[OY��O�b  �a l+ k+ O�a  �*�a l+  k+ !Y hO�M �������pq��
�� .Dat:FDatnull���     ldt �� 0 thedate theDate�� ��rs
�� 
Usinr {����t�� 0 	theformat 	theFormat��  t ��u�� u  ��
�� FDStFDS0s ��vw
�� 
Locav {�������� 0 
localecode 
localeCode��  
�� LclELclSw ��x��
�� 
TZonx {�������� 0 timezone timeZone��  
�� 
msng��  p 	�������������������� 0 thedate theDate�� 0 	theformat 	theFormat�� 0 
localecode 
localeCode�� 0 timezone timeZone�� 0 asocformatter asocFormatter�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eToq 
�����������y������� "0 asdateparameter asDateParameter�� (0 _makedateformatter _makeDateFormatter�� "0 stringfromdate_ stringFromDate_
�� 
ctxt�� 0 etext eTexty ����z
�� 
errn�� 0 enumber eNumberz ����{
�� 
erob�� 0 efrom eFrom{ ������
�� 
errt�� 
0 eto eTo��  �� �� 
0 _error  �� 8 'b  ��l+ E�O*���m+ E�O��k+ �&W X  *祦���+ 	N ������|}��
�� .Dat:PDatnull���     ctxt�� 0 thetext theText�� ��~
�� 
Usin~ {������� 0 	theformat 	theFormat��  � ����� �  ��
�� FDStFDS0 ����
�� 
Loca� {�������� 0 
localecode 
localeCode��  
�� LclELclS� �����
�� 
TZon� {�������� 0 timezone timeZone��  
�� 
msng��  | �������������������������� 0 thetext theText�� 0 	theformat 	theFormat�� 0 
localecode 
localeCode�� 0 timezone timeZone�� 0 asoctext asocText�� 0 asocformatter asocFormatter�� 0 asocdate asocDate�� $0 localeidentifier localeIdentifier�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo} ����8��������������������rz|�����������������������
�� misccura�� 0 nsstring NSString�� "0 astextparameter asTextParameter�� &0 stringwithstring_ stringWithString_�� (0 _makedateformatter _makeDateFormatter�� "0 datefromstring_ dateFromString_
�� 
msng�� 
0 locale  �� $0 localeidentifier localeIdentifier
�� 
ctxt
�� 
leng
�� 
bool
�� 
errn���Y
�� 
erob�� �� 0 
dateformat 
dateFormat
�� 
ldt �� 0 etext eText� �����
�� 
errn�� 0 enumber eNumber� �����
�� 
erob�� 0 efrom eFrom� ������
�� 
errt�� 
0 eto eTo��  �� �� 
0 _error  �� � ���,b  ��l+ k+ E�O*���m+ E�O��k+ E�O��  S�j+ j+ 	E�O�� 
 ��&�,j �& �E�Y 	�%�%E�O)a a a �a a �j+ %a %�%a %Y hO�a &W X  *a ����a + O �����������
�� .Dat:ReDanull��� ��� WebC�� {��������  0 dateproperties dateProperties��  ��  ��  � ����~�}�|�{�z��  0 dateproperties dateProperties� 0 newdate newDate�~ 0 rec  �} 0 etext eText�| 0 enumber eNumber�{ 0 efrom eFrom�z 
0 eto eTo� &��y�x�w�v�u�t�s�r�q�p�o�n�m��l�k�j�i�h�gAf�f�e�d�c�b���.�E�a�`�y &0 asrecordparameter asRecordParameter
�x 
year�w�
�v 
mnth
�u 
day 
�t 
hour
�s 
min 
�r 
scnd
�q 
time
�p 
msng�o 
�n 
long�m 0 etext eText� �_�^�]
�_ 
errn�^�\�]  
�l 
errn�k�Y
�j 
erob
�i 
errt�h 
�g 
enum
�f 
kocl
�e 
nmbr
�d .corecnte****       ****
�c 
ctxt
�b 
bool� �\�[�
�\ 
errn�[ 0 enumber eNumber� �Z�Y�
�Z 
erob�Y 0 efrom eFrom� �X�W�V
�X 
errt�W 
0 eto eTo�V  �a �` 
0 _error  ���b  EQ�Ob  ��l+ ���k�k�j�j�j���%E�O ��,�&��,FW  X  )�a a ��,a �a a �%Ob  ��,kv ��,��,FY 4 ��,�&��,FW %X  )�a a ��,a a �lva a �%O ��,�&��,FW  X  )�a a ��,a �a a �%O��,kva a l j 	 ��,kva a l j a &	 b  ��,kva & !)�a a ��,a a �lva a Y hO��,�  � �Ƣ�,�& E�W  X  )�a a ��,a �a a �%O �Ǣ�,�& E�W  X  )�a a ��,a �a a �%O ���,�&E�W  X  )�a a ��,a �a a  �%Y / ��,�&��,FW  X  )�a a ��,a �a a !�%O�W X  "*a #����a $+ %P �UU�T�S���R
�U .Dat:DaRenull��� ��� ldt �T {�Q�P�O�Q 0 thedate theDate�P  
�O 
msng�S  � �N�M�L�K�J�N 0 thedate theDate�M 0 etext eText�L 0 enumber eNumber�K 0 efrom eFrom�J 
0 eto eTo� �Io�H�G�F�E�D�C�B�A�@�?�>�=�<���;�:
�I 
msng�H "0 asdateparameter asDateParameter
�G 
year
�F 
mnth
�E 
long
�D 
day 
�C 
hour
�B 
time�A
�@ 
min �? <
�> 
scnd�= �< 0 etext eText� �9�8�
�9 
errn�8 0 enumber eNumber� �7�6�
�7 
erob�6 0 efrom eFrom� �5�4�3
�5 
errt�4 
0 eto eTo�3  �; �: 
0 _error  �R _ J��  b  E�Y b  ��l+ E�O��,E��,�&��,E��,�"��,�"�#��,�#�W X  *a ����a + Q �2��1�0���/
�2 .Dat:LiTznull��� ��� null�1  �0  �  � �.�-�,��+�*
�. misccura�- 0 
nstimezone 
NSTimeZone�, (0 knowntimezonenames knownTimeZoneNames�+ 60 sortedarrayusingselector_ sortedArrayUsingSelector_
�* 
list�/ ��,j+ �k+ �&R �)��(�'���&
�) .Dat:CuTznull��� ��� null�(  �'  �  � �%�$�#�"�!
�% misccura�$ 0 
nstimezone 
NSTimeZone�# 0 localtimezone localTimeZone�" 0 name  
�! 
ctxt�& ��,j+ j+ �&S � ������
�  .Dat:TzGMnull��� ��� null�  � ���
� 
From� {���� 0 tzname tzName�  
� 
msng�  � ������ 0 tzname tzName� 0 etext eText� 0 enumber eNumber� 0 efrom eFrom� 
0 eto eTo� ���������
�	&���2��
� 
msng
� misccura� 0 
nstimezone 
NSTimeZone� 0 localtimezone localTimeZone�  0 secondsfromgmt secondsFromGMT
� 
kocl
� 
ctxt
� .corecnte****       ****�
 �	 60 throwinvalidparametertype throwInvalidParameterType� 00 _asnstimezoneparameter _asNSTimeZoneParameter� 0 etext eText� ���
� 
errn� 0 enumber eNumber� ���
� 
erob� 0 efrom eFrom� � ����
�  
errt�� 
0 eto eTo��  � � 
0 _error  � W B��  ��,j+ j+ Y *�kv��l j  *�����+ Y hO*��l+ j+ W X  *a ����a +  ascr  ��ޭ