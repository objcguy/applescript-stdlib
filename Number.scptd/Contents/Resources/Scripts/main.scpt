FasdUAS 1.101.10   ��   ��    k             l      ��  ��   ;5 Number -- manipulate numeric values and perform common math functions

Notes:

- Some handlers originally based on ESG MathLib <http://www.esglabs.com/>, which in turn are conversions of the ones in the Cephes Mathematical Library by Stephen L. Moshier <http://netlib.org/cephes/>.


TO DO: 

- BUG: allowing fixed �1.0e-9 difference between numbers is problematic as it doesn't work for comparisons between two very large or two very small numbers; e.g. `cmp{1e-100,2e-100}` should return -1 (1<2) but returns 0 (1=2); what it really needs to do is calculate `N�N*1e-9` and use that as the margin (with special-case for where N=0); also fix this bug in TestTools's `numeric equality check`; in addition, this adjustment should only apply when one or both numbers are reals, NOT when both are integers

- BUG: `plain` option in number formatter rounds off fractional numbers to whole, which is no good; need to use decimal/scientific for `canonical` representation (c.f. AS always uses decimal notation for `integer` numbers and switches from decimal to sci notations for `real` numbers at approximately >�1e4 and <�1e-3)


- what else needs implemented? e.g. atan2? (note that trivial operations such as `hypotenuse`, `square` and `square root` are not implemented as those are simple to do using AS's existing `^` operator (e.g. sqrt(n)=n^0.5), while `floor`, `ceil`, etc. are already covered by `round number`


- add optional parameter to `format number` for specifying decimal places and padding (these are common tasks, so accept e.g. a record containing one or more of: [maximum] decimal places, minimum decimal places, rounding method, minimum integral places)

- `format number` and `round number` should both support the same rounding options (i.e. all rounding behaviors supported by NSNumberFormatter)


- `parse/format hexadecimal number` should include support for parsing/formatting list of numbers as single hex string, based on fixed-width hex sequences (i.e. add optional `of width INTEGER` parameter to both commands; if given, switch from single-integer to list-of-integer mode)

     � 	 	j   N u m b e r   - -   m a n i p u l a t e   n u m e r i c   v a l u e s   a n d   p e r f o r m   c o m m o n   m a t h   f u n c t i o n s 
 
 N o t e s : 
 
 -   S o m e   h a n d l e r s   o r i g i n a l l y   b a s e d   o n   E S G   M a t h L i b   < h t t p : / / w w w . e s g l a b s . c o m / > ,   w h i c h   i n   t u r n   a r e   c o n v e r s i o n s   o f   t h e   o n e s   i n   t h e   C e p h e s   M a t h e m a t i c a l   L i b r a r y   b y   S t e p h e n   L .   M o s h i e r   < h t t p : / / n e t l i b . o r g / c e p h e s / > . 
 
 
 T O   D O :   
 
 -   B U G :   a l l o w i n g   f i x e d   � 1 . 0 e - 9   d i f f e r e n c e   b e t w e e n   n u m b e r s   i s   p r o b l e m a t i c   a s   i t   d o e s n ' t   w o r k   f o r   c o m p a r i s o n s   b e t w e e n   t w o   v e r y   l a r g e   o r   t w o   v e r y   s m a l l   n u m b e r s ;   e . g .   ` c m p { 1 e - 1 0 0 , 2 e - 1 0 0 } `   s h o u l d   r e t u r n   - 1   ( 1 < 2 )   b u t   r e t u r n s   0   ( 1 = 2 ) ;   w h a t   i t   r e a l l y   n e e d s   t o   d o   i s   c a l c u l a t e   ` N � N * 1 e - 9 `   a n d   u s e   t h a t   a s   t h e   m a r g i n   ( w i t h   s p e c i a l - c a s e   f o r   w h e r e   N = 0 ) ;   a l s o   f i x   t h i s   b u g   i n   T e s t T o o l s ' s   ` n u m e r i c   e q u a l i t y   c h e c k ` ;   i n   a d d i t i o n ,   t h i s   a d j u s t m e n t   s h o u l d   o n l y   a p p l y   w h e n   o n e   o r   b o t h   n u m b e r s   a r e   r e a l s ,   N O T   w h e n   b o t h   a r e   i n t e g e r s 
 
 -   B U G :   ` p l a i n `   o p t i o n   i n   n u m b e r   f o r m a t t e r   r o u n d s   o f f   f r a c t i o n a l   n u m b e r s   t o   w h o l e ,   w h i c h   i s   n o   g o o d ;   n e e d   t o   u s e   d e c i m a l / s c i e n t i f i c   f o r   ` c a n o n i c a l `   r e p r e s e n t a t i o n   ( c . f .   A S   a l w a y s   u s e s   d e c i m a l   n o t a t i o n   f o r   ` i n t e g e r `   n u m b e r s   a n d   s w i t c h e s   f r o m   d e c i m a l   t o   s c i   n o t a t i o n s   f o r   ` r e a l `   n u m b e r s   a t   a p p r o x i m a t e l y   > � 1 e 4   a n d   < � 1 e - 3 ) 
 
 
 -   w h a t   e l s e   n e e d s   i m p l e m e n t e d ?   e . g .   a t a n 2 ?   ( n o t e   t h a t   t r i v i a l   o p e r a t i o n s   s u c h   a s   ` h y p o t e n u s e ` ,   ` s q u a r e `   a n d   ` s q u a r e   r o o t `   a r e   n o t   i m p l e m e n t e d   a s   t h o s e   a r e   s i m p l e   t o   d o   u s i n g   A S ' s   e x i s t i n g   ` ^ `   o p e r a t o r   ( e . g .   s q r t ( n ) = n ^ 0 . 5 ) ,   w h i l e   ` f l o o r ` ,   ` c e i l ` ,   e t c .   a r e   a l r e a d y   c o v e r e d   b y   ` r o u n d   n u m b e r ` 
 
 
 -   a d d   o p t i o n a l   p a r a m e t e r   t o   ` f o r m a t   n u m b e r `   f o r   s p e c i f y i n g   d e c i m a l   p l a c e s   a n d   p a d d i n g   ( t h e s e   a r e   c o m m o n   t a s k s ,   s o   a c c e p t   e . g .   a   r e c o r d   c o n t a i n i n g   o n e   o r   m o r e   o f :   [ m a x i m u m ]   d e c i m a l   p l a c e s ,   m i n i m u m   d e c i m a l   p l a c e s ,   r o u n d i n g   m e t h o d ,   m i n i m u m   i n t e g r a l   p l a c e s ) 
 
 -   ` f o r m a t   n u m b e r `   a n d   ` r o u n d   n u m b e r `   s h o u l d   b o t h   s u p p o r t   t h e   s a m e   r o u n d i n g   o p t i o n s   ( i . e .   a l l   r o u n d i n g   b e h a v i o r s   s u p p o r t e d   b y   N S N u m b e r F o r m a t t e r ) 
 
 
 -   ` p a r s e / f o r m a t   h e x a d e c i m a l   n u m b e r `   s h o u l d   i n c l u d e   s u p p o r t   f o r   p a r s i n g / f o r m a t t i n g   l i s t   o f   n u m b e r s   a s   s i n g l e   h e x   s t r i n g ,   b a s e d   o n   f i x e d - w i d t h   h e x   s e q u e n c e s   ( i . e .   a d d   o p t i o n a l   ` o f   w i d t h   I N T E G E R `   p a r a m e t e r   t o   b o t h   c o m m a n d s ;   i f   g i v e n ,   s w i t c h   f r o m   s i n g l e - i n t e g e r   t o   l i s t - o f - i n t e g e r   m o d e ) 
 
   
  
 l     ��������  ��  ��        l     ��������  ��  ��        x     �� ����    4    �� 
�� 
frmk  m       �    F o u n d a t i o n��        l     ��������  ��  ��        x    �� ����    2   ��
�� 
osax��        l     ��������  ��  ��        l     ��  ��    J D--------------------------------------------------------------------     �   � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -     !   l     �� " #��   "   support    # � $ $    s u p p o r t !  % & % l     ��������  ��  ��   &  ' ( ' l      ) * + ) j    �� ,�� 0 _support   , N     - - 4    �� .
�� 
scpt . m     / / � 0 0  T y p e S u p p o r t * "  used for parameter checking    + � 1 1 8   u s e d   f o r   p a r a m e t e r   c h e c k i n g (  2 3 2 l     ��������  ��  ��   3  4 5 4 i   ! 6 7 6 I      �� 8���� 
0 _error   8  9 : 9 o      ���� 0 handlername handlerName :  ; < ; o      ���� 0 etext eText <  = > = o      ���� 0 enumber eNumber >  ? @ ? o      ���� 0 efrom eFrom @  A�� A o      ���� 
0 eto eTo��  ��   7 n     B C B I    �� D���� &0 throwcommanderror throwCommandError D  E F E m     G G � H H  N u m b e r F  I J I o    ���� 0 handlername handlerName J  K L K o    ���� 0 etext eText L  M N M o    	���� 0 enumber eNumber N  O P O o   	 
���� 0 efrom eFrom P  Q�� Q o   
 ���� 
0 eto eTo��  ��   C o     ���� 0 _support   5  R S R l     ��������  ��  ��   S  T U T l     ��������  ��  ��   U  V W V l     �� X Y��   X J D--------------------------------------------------------------------    Y � Z Z � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - W  [ \ [ l     �� ] ^��   ]  
 constants    ^ � _ _    c o n s t a n t s \  ` a ` l     ��������  ��  ��   a  b c b l      d e f d j   " $�� g�� 	0 __e__   g m   " # h h @�
�_� e ; 5 The mathematical constant e (natural logarithm base)    f � i i j   T h e   m a t h e m a t i c a l   c o n s t a n t   e   ( n a t u r a l   l o g a r i t h m   b a s e ) c  j k j l     ��������  ��  ��   k  l m l j   % '�� n�� 0 _isequaldelta _isEqualDelta n m   % & o o >.�&֕ m  p q p l     ��������  ��  ��   q  r s r l     �� t u��   t � � pre-calculated values (0-360� in 15� increments) -- TO DO: precalculate for 1� increments? (also, would be sufficient to calculate for 0-90�)    u � v v   p r e - c a l c u l a t e d   v a l u e s   ( 0 - 3 6 0 �   i n   1 5 �   i n c r e m e n t s )   - -   T O   D O :   p r e c a l c u l a t e   f o r   1 �   i n c r e m e n t s ?   ( a l s o ,   w o u l d   b e   s u f f i c i e n t   t o   c a l c u l a t e   f o r   0 - 9 0 � ) s  w x w j   ( e�� y�� 0 _precalcsine _precalcSine y J   ( d z z  { | { m   ( ) } }          |  ~  ~ m   ) * � � ?А}��(J   � � � m   * + � � ?�       �  � � � m   + , � � ?栞fK� �  � � � m   , / � � ?�z�X=; �  � � � m   / 2 � � ?���GH�� �  � � � m   2 5 � � ?�       �  � � � m   5 8 � � ?���GH�� �  � � � m   8 ; � � ?�z�X=; �  � � � m   ; < � � ?栞fK� �  � � � m   < = � � ?�       �  � � � m   = > � � ?А}��(J �  � � � m   > ? � �          �  � � � m   ? B � � �А}��(J �  � � � m   B E � � ��       �  � � � m   E H � � �栞fK� �  � � � m   H K � � ��z�X=; �  � � � m   K N � � ����GH�� �  � � � m   N Q � � ��       �  � � � m   Q T � � ����GH�� �  � � � m   T W � � ��z�X=; �  � � � m   W Z � � �栞fK� �  � � � m   Z ] � � ��       �  ��� � m   ] ` � � �А}��(J��   x  � � � j   f ��� ��� "0 _precalctangent _precalcTangent � J   f � � �  � � � m   f g � �          �  � � � m   g j � � ?�&^�Ĵ �  � � � m   j m � � ?�y�E�@G �  � � � m   m p � � ?�       �  � � � m   p s � � ?��z�XN� �  � � � m   s v � � @�=t,'j �  � � � m   v y��
�� 
msng �  � � � m   y | � � ��=t,'j �  � � � m   |  � � ���z�XN� �  � � � m    � � � ��       �  � � � m   � � � � ��y�E�@G �  � � � m   � � � � ��&^�Ĵ �  � � � m   � � � �          �  � � � m   � � � � ?�&^�Ĵ �  � � � m   � � � � ?�y�E�@G �  � � � m   � � � � ?�       �  � � � m   � � � � ?��z�XN� �  � � � m   � � � � @�=t,'j �  � � � m   � ���
�� 
msng �  � � � m   � � � � ��=t,'j �    m   � � ���z�XN�  m   � � ��        m   � � ��y�E�@G 	��	 m   � �

 ��&^�Ĵ��   �  l     ��������  ��  ��    l     ��������  ��  ��    l     ����   J D--------------------------------------------------------------------    � � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  l     ����     parse and format    � "   p a r s e   a n d   f o r m a t  l     ��������  ��  ��    i  � � I      ������ ,0 _makenumberformatter _makeNumberFormatter  !  o      ���� 0 formatstyle formatStyle! "��" o      ���� 0 
localecode 
localeCode��  ��   l    �#$%# k     �&& '(' r     )*) n    +,+ I    �������� 0 init  ��  ��  , n    -.- I    �������� 	0 alloc  ��  ��  . n    /0/ o    ���� &0 nsnumberformatter NSNumberFormatter0 m     ��
�� misccura* o      ���� 0 asocformatter asocFormatter( 121 Z    �34563 =   787 o    ���� 0 formatstyle formatStyle8 m    ��
�� FNStFNS44 l   9:;9 n   <=< I    ��>���� "0 setnumberstyle_ setNumberStyle_> ?��? l   @����@ n   ABA o    ���� D0  nsnumberformatterscientificstyle  NSNumberFormatterScientificStyleB m    ��
�� misccura��  ��  ��  ��  = o    ���� 0 asocformatter asocFormatter:   uses exponent notation   ; �CC .   u s e s   e x p o n e n t   n o t a t i o n5 DED =   "FGF o     ���� 0 formatstyle formatStyleG m     !��
�� FNStFNS0E HIH l  % -JKLJ n  % -MNM I   & -��O���� "0 setnumberstyle_ setNumberStyle_O P��P l  & )Q����Q n  & )RSR o   ' )���� 40 nsnumberformatternostyle NSNumberFormatterNoStyleS m   & '��
�� misccura��  ��  ��  ��  N o   % &���� 0 asocformatter asocFormatterK "  uses plain integer notation   L �TT 8   u s e s   p l a i n   i n t e g e r   n o t a t i o nI UVU =  0 3WXW o   0 1���� 0 formatstyle formatStyleX m   1 2��
�� FNStFNS1V YZY l  6 >[\][ n  6 >^_^ I   7 >��`���� "0 setnumberstyle_ setNumberStyle_` a��a l  7 :b����b n  7 :cdc o   8 :���� >0 nsnumberformatterdecimalstyle NSNumberFormatterDecimalStyled m   7 8��
�� misccura��  ��  ��  ��  _ o   6 7���� 0 asocformatter asocFormatter\ - ' uses thousands separators, no exponent   ] �ee N   u s e s   t h o u s a n d s   s e p a r a t o r s ,   n o   e x p o n e n tZ fgf =  A Dhih o   A B�� 0 formatstyle formatStylei m   B C�~
�~ FNStFNS2g jkj l  G Olmnl n  G Oopo I   H O�}q�|�} "0 setnumberstyle_ setNumberStyle_q r�{r l  H Ks�z�ys n  H Ktut o   I K�x�x @0 nsnumberformattercurrencystyle NSNumberFormatterCurrencyStyleu m   H I�w
�w misccura�z  �y  �{  �|  p o   G H�v�v 0 asocformatter asocFormatterm   adds currency symbol   n �vv *   a d d s   c u r r e n c y   s y m b o lk wxw =  R Uyzy o   R S�u�u 0 formatstyle formatStylez m   S T�t
�t FNStFNS3x {|{ l  X `}~} n  X `��� I   Y `�s��r�s "0 setnumberstyle_ setNumberStyle_� ��q� l  Y \��p�o� n  Y \��� o   Z \�n�n >0 nsnumberformatterpercentstyle NSNumberFormatterPercentStyle� m   Y Z�m
�m misccura�p  �o  �q  �r  � o   X Y�l�l 0 asocformatter asocFormatter~ ( " multiplies by 100 and appends '%'    ��� D   m u l t i p l i e s   b y   1 0 0   a n d   a p p e n d s   ' % '| ��� =  c f��� o   c d�k�k 0 formatstyle formatStyle� m   d e�j
�j FNStFNS5� ��i� l  i s���� n  i s��� I   j s�h��g�h "0 setnumberstyle_ setNumberStyle_� ��f� l  j o��e�d� n  j o��� o   k o�c�c @0 nsnumberformatterspelloutstyle NSNumberFormatterSpellOutStyle� m   j k�b
�b misccura�e  �d  �f  �g  � o   i j�a�a 0 asocformatter asocFormatter�   uses words   � ���    u s e s   w o r d s�i  6 R   v ��`��
�` .ascrerr ****      � ****� m   � ��� ��� b I n v a l i d    i n    p a r a m e t e r   ( n o t   a n   a l l o w e d   c o n s t a n t ) .� �_��
�_ 
errn� m   z }�^�^�Y� �]��
�] 
erob� o   � ��\�\ 0 formatstyle formatStyle� �[��Z
�[ 
errt� m   � ��Y
�Y 
enum�Z  2 ��� n  � ���� I   � ��X��W�X 0 
setlocale_ 
setLocale_� ��V� l  � ���U�T� n  � ���� I   � ��S��R�S *0 asnslocaleparameter asNSLocaleParameter� ��� o   � ��Q�Q 0 
localecode 
localeCode� ��P� m   � ��� ���  f o r   l o c a l e�P  �R  � o   � ��O�O 0 _support  �U  �T  �V  �W  � o   � ��N�N 0 asocformatter asocFormatter� ��� l  � ��M���M  � (note that while NSFormatter provides a global +setDefaultFormatterBehavior: option to change all NSNumberFormatters to use pre-10.4 behavior, we don't bother to setFormatterBehavior: on the assumption that it's highly unlikely nowadays that a host process would do this)   � ���    ( n o t e   t h a t   w h i l e   N S F o r m a t t e r   p r o v i d e s   a   g l o b a l   + s e t D e f a u l t F o r m a t t e r B e h a v i o r :   o p t i o n   t o   c h a n g e   a l l   N S N u m b e r F o r m a t t e r s   t o   u s e   p r e - 1 0 . 4   b e h a v i o r ,   w e   d o n ' t   b o t h e r   t o   s e t F o r m a t t e r B e h a v i o r :   o n   t h e   a s s u m p t i o n   t h a t   i t ' s   h i g h l y   u n l i k e l y   n o w a d a y s   t h a t   a   h o s t   p r o c e s s   w o u l d   d o   t h i s )� ��L� L   � ��� o   � ��K�K 0 asocformatter asocFormatter�L  $ o i note: this doesn't handle `default format` option as the appropriate default may vary according to usage   % ��� �   n o t e :   t h i s   d o e s n ' t   h a n d l e   ` d e f a u l t   f o r m a t `   o p t i o n   a s   t h e   a p p r o p r i a t e   d e f a u l t   m a y   v a r y   a c c o r d i n g   t o   u s a g e ��� l     �J�I�H�J  �I  �H  � ��� l     �G�F�E�G  �F  �E  � ��� i  � ���� I      �D��C�D $0 _setroundingmode _setRoundingMode� ��� o      �B�B "0 numberformatter numberFormatter� ��A� o      �@�@ &0 roundingdirection roundingDirection�A  �C  � l    ����� Z     ������ =    ��� o     �?�? &0 roundingdirection roundingDirection� l   ��>�=� m    �<
�< MRndRNhE�>  �=  � n   ��� I    �;��:�; $0 setroundingmode_ setRoundingMode_� ��9� l   
��8�7� n   
��� o    
�6�6 @0 nsnumberformatterroundhalfeven NSNumberFormatterRoundHalfEven� m    �5
�5 misccura�8  �7  �9  �:  � o    �4�4 "0 numberformatter numberFormatter� ��� =   ��� o    �3�3 &0 roundingdirection roundingDirection� l   ��2�1� m    �0
�0 MRndRNhT�2  �1  � ��� n   ��� I    �/��.�/ $0 setroundingmode_ setRoundingMode_� ��-� l   ��,�+� n   ��� o    �*�* @0 nsnumberformatterroundhalfdown NSNumberFormatterRoundHalfDown� m    �)
�) misccura�,  �+  �-  �.  � o    �(�( "0 numberformatter numberFormatter� ��� =  " %��� o   " #�'�' &0 roundingdirection roundingDirection� l  # $��&�%� m   # $�$
�$ MRndRNhF�&  �%  � ��� n  ( 0��� I   ) 0�#��"�# $0 setroundingmode_ setRoundingMode_� ��!� l  ) ,�� �� n  ) ,��� o   * ,�� <0 nsnumberformatterroundhalfup NSNumberFormatterRoundHalfUp� m   ) *�
� misccura�   �  �!  �"  � o   ( )�� "0 numberformatter numberFormatter� ��� =  3 6��� o   3 4�� &0 roundingdirection roundingDirection� l  4 5���� m   4 5�
� MRndRN_T�  �  � ��� n  9 A��� I   : A���� $0 setroundingmode_ setRoundingMode_� ��� l  : =���� n  : =��� o   ; =�� 80 nsnumberformatterrounddown NSNumberFormatterRoundDown� m   : ;�
� misccura�  �  �  �  � o   9 :�� "0 numberformatter numberFormatter� � � =  D G o   D E�� &0 roundingdirection roundingDirection l  E F�� m   E F�
� MRndRN_F�  �     n  J R I   K R��
� $0 setroundingmode_ setRoundingMode_ 	�		 l  K N
��
 n  K N o   L N�� 40 nsnumberformatterroundup NSNumberFormatterRoundUp m   K L�
� misccura�  �  �	  �
   o   J K�� "0 numberformatter numberFormatter  =  U X o   U V�� &0 roundingdirection roundingDirection l  V W�� m   V W� 
�  MRndRN_U�  �    n  [ c I   \ c������ $0 setroundingmode_ setRoundingMode_ �� l  \ _���� n  \ _ o   ] _���� >0 nsnumberformatterroundceiling NSNumberFormatterRoundCeiling m   \ ]��
�� misccura��  ��  ��  ��   o   [ \���� "0 numberformatter numberFormatter  =  f i o   f g���� &0 roundingdirection roundingDirection l  g h���� m   g h��
�� MRndRN_D��  ��    ��  n  l t!"! I   m t��#���� $0 setroundingmode_ setRoundingMode_# $��$ l  m p%����% n  m p&'& o   n p���� :0 nsnumberformatterroundfloor NSNumberFormatterRoundFloor' m   m n��
�� misccura��  ��  ��  ��  " o   l m���� "0 numberformatter numberFormatter��  � n  w �()( I   | ���*���� >0 throwinvalidparameterconstant throwInvalidParameterConstant* +,+ o   | }���� &0 roundingdirection roundingDirection, -��- m   } �.. �//  b y��  ��  ) o   w |���� 0 _support  �   TO DO: finish   � �00    T O   D O :   f i n i s h� 121 l     ��������  ��  ��  2 343 l     ��������  ��  ��  4 565 i  � �787 I      ��9����  0 _nameforformat _nameForFormat9 :��: o      ���� 0 formatstyle formatStyle��  ��  8 l    H;<=; Z     H>?@A> =    BCB o     ���� 0 formatstyle formatStyleC m    ��
�� FNStFNS0? L    DD m    EE �FF  i n t e g e r@ GHG =   IJI o    ���� 0 formatstyle formatStyleJ m    ��
�� FNStFNS1H KLK L    MM m    NN �OO  d e c i m a lL PQP =   RSR o    ���� 0 formatstyle formatStyleS m    ��
�� FNStFNS2Q TUT L    VV m    WW �XX  c u r r e n c yU YZY =  ! $[\[ o   ! "���� 0 formatstyle formatStyle\ m   " #��
�� FNStFNS3Z ]^] L   ' )__ m   ' (`` �aa  p e r c e n t^ bcb =  , /ded o   , -���� 0 formatstyle formatStylee m   - .��
�� FNStFNS4c fgf L   2 4hh m   2 3ii �jj  s c i e n t i f i cg klk =  7 :mnm o   7 8���� 0 formatstyle formatStylen m   8 9��
�� FNStFNS5l o��o L   = ?pp m   = >qq �rr  w o r d��  A L   B Hss b   B Gtut b   B Evwv m   B Cxx �yy  w o   C D���� 0 formatstyle formatStyleu m   E Fzz �{{  < G A used for error reporting; formatStyle is either constant or text   = �|| �   u s e d   f o r   e r r o r   r e p o r t i n g ;   f o r m a t S t y l e   i s   e i t h e r   c o n s t a n t   o r   t e x t6 }~} l     ��������  ��  ��  ~ � l     ��������  ��  ��  � ��� i  � ���� I      �������� 60 _canonicalnumberformatter _canonicalNumberFormatter��  ��  � l    &���� k     &�� ��� r     ��� n    ��� I    �������� 0 init  ��  ��  � n    ��� I    �������� 	0 alloc  ��  ��  � n    ��� o    ���� &0 nsnumberformatter NSNumberFormatter� m     ��
�� misccura� o      ���� 0 asocformatter asocFormatter� ��� n   ��� I    ������� "0 setnumberstyle_ setNumberStyle_� ���� l   ������ n   ��� o    ���� D0  nsnumberformatterscientificstyle  NSNumberFormatterScientificStyle� m    ��
�� misccura��  ��  ��  ��  � o    ���� 0 asocformatter asocFormatter� ��� l   #���� n   #��� I    #������� 0 
setlocale_ 
setLocale_� ���� l   ������ n   ��� I    �������� 0 systemlocale systemLocale��  ��  � n   ��� o    ���� 0 nslocale NSLocale� m    ��
�� misccura��  ��  ��  ��  � o    ���� 0 asocformatter asocFormatter� [ U note: NSNumberFormatter uses currentLocale by default, which isn't what we want here   � ��� �   n o t e :   N S N u m b e r F o r m a t t e r   u s e s   c u r r e n t L o c a l e   b y   d e f a u l t ,   w h i c h   i s n ' t   w h a t   w e   w a n t   h e r e� ���� L   $ &�� o   $ %���� 0 asocformatter asocFormatter��  � . ( TO DO: use this for complex formatting?   � ��� P   T O   D O :   u s e   t h i s   f o r   c o m p l e x   f o r m a t t i n g ?� ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� l     ������  �  -----   � ��� 
 - - - - -� ��� l     ��������  ��  ��  � ��� l     ������  � � � TO DO: allow `using` to be either constant or `numeric format record` record of formatting options {format type:FNSt, minimum decimal places:INTEGER, maximum decimal places:INTEGER, rounding:MRnd, [what else]}   � ����   T O   D O :   a l l o w   ` u s i n g `   t o   b e   e i t h e r   c o n s t a n t   o r   ` n u m e r i c   f o r m a t   r e c o r d `   r e c o r d   o f   f o r m a t t i n g   o p t i o n s   { f o r m a t   t y p e : F N S t ,   m i n i m u m   d e c i m a l   p l a c e s : I N T E G E R ,   m a x i m u m   d e c i m a l   p l a c e s : I N T E G E R ,   r o u n d i n g : M R n d ,   [ w h a t   e l s e ] }� ��� l     ��������  ��  ��  � ��� i  � ���� I     ����
�� .Mth:FNumnull���     nmbr� o      ���� 0 	thenumber 	theNumber� ����
�� 
Usin� |����������  ��  � o      ���� 0 formatstyle formatStyle��  � l     ������ m      ��
�� FNStFNSD��  ��  � �����
�� 
Loca� |����������  ��  � o      ���� 0 
localecode 
localeCode��  � l     ������ m      ��
�� 
msng��  ��  ��  � l    ����� k     ��� ��� l      ������  �zt -setRoundingMode:
		NSNumberFormatterRoundCeiling
		NSNumberFormatterRoundFloor
		NSNumberFormatterRoundDown -- toward zero
		NSNumberFormatterRoundUp -- away from zero (aka `as taught in school`)
		NSNumberFormatterRoundHalfEven
		NSNumberFormatterRoundHalfDown -- note that `round number` currently doesn't support half-down and half-up
		NSNumberFormatterRoundHalfUp
	   � ����   - s e t R o u n d i n g M o d e : 
 	 	 N S N u m b e r F o r m a t t e r R o u n d C e i l i n g 
 	 	 N S N u m b e r F o r m a t t e r R o u n d F l o o r 
 	 	 N S N u m b e r F o r m a t t e r R o u n d D o w n   - -   t o w a r d   z e r o 
 	 	 N S N u m b e r F o r m a t t e r R o u n d U p   - -   a w a y   f r o m   z e r o   ( a k a   ` a s   t a u g h t   i n   s c h o o l ` ) 
 	 	 N S N u m b e r F o r m a t t e r R o u n d H a l f E v e n 
 	 	 N S N u m b e r F o r m a t t e r R o u n d H a l f D o w n   - -   n o t e   t h a t   ` r o u n d   n u m b e r `   c u r r e n t l y   d o e s n ' t   s u p p o r t   h a l f - d o w n   a n d   h a l f - u p 
 	 	 N S N u m b e r F o r m a t t e r R o u n d H a l f U p 
 	� ���� Q     ����� k    q�� ��� Z    "������� =    ��� l   ������ I   ���
� .corecnte****       ****� J    �� ��~� o    �}�} 0 	thenumber 	theNumber�~  � �|��{
�| 
kocl� m    �z
�z 
nmbr�{  ��  ��  � m    �y�y  � l   ���� n   ��� I    �x��w�x 60 throwinvalidparametertype throwInvalidParameterType� ��� o    �v�v 0 	thenumber 	theNumber� ��� m    �� ���  � ��� m    �� ���  n u m b e r� ��u� m    �t
�t 
nmbr�u  �w  � o    �s�s 0 _support  � � � only accept integer or real types (i.e. allowing a text parameter to be coerced to number would defeat the purpose of these handlers, which is to guarantee non-localized conversions)   � ���n   o n l y   a c c e p t   i n t e g e r   o r   r e a l   t y p e s   ( i . e .   a l l o w i n g   a   t e x t   p a r a m e t e r   t o   b e   c o e r c e d   t o   n u m b e r   w o u l d   d e f e a t   t h e   p u r p o s e   o f   t h e s e   h a n d l e r s ,   w h i c h   i s   t o   g u a r a n t e e   n o n - l o c a l i z e d   c o n v e r s i o n s )��  ��  � ��� Z   # >���r�q� =  # &� � o   # $�p�p 0 formatstyle formatStyle  m   $ %�o
�o FNStFNSD� Z   ) :�n =  ) . n  ) , m   * ,�m
�m 
pcls o   ) *�l�l 0 	thenumber 	theNumber m   , -�k
�k 
long r   1 4	 m   1 2�j
�j FNStFNS0	 o      �i�i 0 formatstyle formatStyle�n   r   7 :

 m   7 8�h
�h FNStFNS4 o      �g�g 0 formatstyle formatStyle�r  �q  �  r   ? H I   ? F�f�e�f ,0 _makenumberformatter _makeNumberFormatter  o   @ A�d�d 0 formatstyle formatStyle �c o   A B�b�b 0 
localecode 
localeCode�c  �e   o      �a�a 0 asocformatter asocFormatter  r   I Q n  I O I   J O�`�_�` &0 stringfromnumber_ stringFromNumber_ �^ o   J K�]�] 0 	thenumber 	theNumber�^  �_   o   I J�\�\ 0 asocformatter asocFormatter o      �[�[ 0 
asocstring 
asocString  l  R j  Z  R j!"�Z�Y! =  R U#$# o   R S�X�X 0 
asocstring 
asocString$ m   S T�W
�W 
msng" R   X f�V%&
�V .ascrerr ****      � ****% m   b e'' �(( F I n v a l i d   n u m b e r   ( c o n v e r s i o n   f a i l e d ) .& �U)*
�U 
errn) m   Z ]�T�T�Y* �S+�R
�S 
erob+ o   ` a�Q�Q 0 	thenumber 	theNumber�R  �Z  �Y   n h shouldn't fail, but -stringFromNumber:'s return type isn't declared as non-nullable so check to be sure     �,, �   s h o u l d n ' t   f a i l ,   b u t   - s t r i n g F r o m N u m b e r : ' s   r e t u r n   t y p e   i s n ' t   d e c l a r e d   a s   n o n - n u l l a b l e   s o   c h e c k   t o   b e   s u r e -�P- L   k q.. c   k p/0/ o   k l�O�O 0 
asocstring 
asocString0 m   l o�N
�N 
ctxt�P  � R      �M12
�M .ascrerr ****      � ****1 o      �L�L 0 etext eText2 �K34
�K 
errn3 o      �J�J 0 enumber eNumber4 �I56
�I 
erob5 o      �H�H 0 efrom eFrom6 �G7�F
�G 
errt7 o      �E�E 
0 eto eTo�F  � I   y ��D8�C�D 
0 _error  8 9:9 m   z };; �<<  f o r m a t   n u m b e r: =>= o   } ~�B�B 0 etext eText> ?@? o   ~ �A�A 0 enumber eNumber@ ABA o    ��@�@ 0 efrom eFromB C�?C o   � ��>�> 
0 eto eTo�?  �C  ��  � E ? TO DO: optional param for specifying places, padding, rounding   � �DD ~   T O   D O :   o p t i o n a l   p a r a m   f o r   s p e c i f y i n g   p l a c e s ,   p a d d i n g ,   r o u n d i n g� EFE l     �=�<�;�=  �<  �;  F GHG l     �:�9�8�:  �9  �8  H IJI i  � �KLK I     �7MN
�7 .Mth:PNumnull���     ctxtM o      �6�6 0 thetext theTextN �5OP
�5 
UsinO |�4�3Q�2R�4  �3  Q o      �1�1 0 formatstyle formatStyle�2  R l     S�0�/S m      �.
�. FNStFNSD�0  �/  P �-T�,
�- 
LocaT |�+�*U�)V�+  �*  U o      �(�( 0 
localecode 
localeCode�)  V l     W�'�&W m      �%
�% 
msng�'  �&  �,  L Q     �XYZX k    �[[ \]\ Z    "^_�$�#^ =    `a` l   b�"�!b I   � cd
�  .corecnte****       ****c J    ee f�f o    �� 0 thetext theText�  d �g�
� 
koclg m    �
� 
ctxt�  �"  �!  a m    ��  _ l   hijh n   klk I    �m�� 60 throwinvalidparametertype throwInvalidParameterTypem non o    �� 0 thetext theTexto pqp m    rr �ss  q tut m    vv �ww  t e x tu x�x m    �
� 
ctxt�  �  l o    �� 0 _support  i � � only accept text (i.e. allowing an integer/real parameter to be coerced to text would defeat the purpose of these handlers, which is to guarantee non-localized conversions)   j �yyZ   o n l y   a c c e p t   t e x t   ( i . e .   a l l o w i n g   a n   i n t e g e r / r e a l   p a r a m e t e r   t o   b e   c o e r c e d   t o   t e x t   w o u l d   d e f e a t   t h e   p u r p o s e   o f   t h e s e   h a n d l e r s ,   w h i c h   i s   t o   g u a r a n t e e   n o n - l o c a l i z e d   c o n v e r s i o n s )�$  �#  ] z{z Z  # 0|}��| =  # &~~ o   # $�� 0 formatstyle formatStyle m   $ %�
� FNStFNSD} r   ) ,��� m   ) *�
� FNStFNS4� o      �� 0 formatstyle formatStyle�  �  { ��� r   1 :��� I   1 8���� ,0 _makenumberformatter _makeNumberFormatter� ��� o   2 3�� 0 formatstyle formatStyle� ��
� o   3 4�	�	 0 
localecode 
localeCode�
  �  � o      �� 0 asocformatter asocFormatter� ��� r   ; C��� n  ; A��� I   < A���� &0 numberfromstring_ numberFromString_� ��� o   < =�� 0 thetext theText�  �  � o   ; <�� 0 asocformatter asocFormatter� o      �� 0 
asocnumber 
asocNumber� ��� Z   D ����� � =  D G��� o   D E���� 0 
asocnumber 
asocNumber� m   E F��
�� 
msng� k   J ��� ��� r   J W��� c   J U��� n  J S��� I   O S�������� $0 localeidentifier localeIdentifier��  ��  � n  J O��� I   K O�������� 
0 locale  ��  ��  � o   J K���� 0 asocformatter asocFormatter� m   S T��
�� 
ctxt� o      ���� $0 localeidentifier localeIdentifier� ��� Z   X q������ =   X ]��� n  X [��� 1   Y [��
�� 
leng� o   X Y���� $0 localeidentifier localeIdentifier� m   [ \����  � l  ` c���� r   ` c��� m   ` a�� ���  n o� o      ���� $0 localeidentifier localeIdentifier� #  empty string = system locale   � ��� :   e m p t y   s t r i n g   =   s y s t e m   l o c a l e��  � r   f q��� b   f o��� b   f k��� m   f i�� ��� 
 t h e   � o   i j���� $0 localeidentifier localeIdentifier� m   k n�� ���  � o      ���� $0 localeidentifier localeIdentifier� ���� R   r �����
�� .ascrerr ****      � ****� l  ~ ������� b   ~ ���� b   ~ ���� b   ~ ���� b   ~ ���� m   ~ ��� ��� R I n v a l i d   t e x t   ( e x p e c t e d   n u m e r i c a l   t e x t   i n  � I   � ��������  0 _nameforformat _nameForFormat� ���� o   � ����� 0 formatstyle formatStyle��  ��  � m   � ��� ���    f o r m a t   f o r  � o   � ����� $0 localeidentifier localeIdentifier� m   � ��� ���    l o c a l e ) .��  ��  � ����
�� 
errn� m   v y�����Y� �����
�� 
erob� o   | }���� 0 thetext theText��  ��  �  �   � ���� L   � ��� c   � ���� o   � ����� 0 
asocnumber 
asocNumber� m   � ���
�� 
****��  Y R      ����
�� .ascrerr ****      � ****� o      ���� 0 etext eText� ����
�� 
errn� o      ���� 0 enumber eNumber� ����
�� 
erob� o      ���� 0 efrom eFrom� �����
�� 
errt� o      ���� 
0 eto eTo��  Z I   � �������� 
0 _error  � ��� m   � ��� ���  p a r s e   n u m b e r� ��� o   � ����� 0 etext eText� ��� o   � ����� 0 enumber eNumber� ��� o   � ����� 0 efrom eFrom� ���� o   � ����� 
0 eto eTo��  ��  J ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� l     ������  � J D--------------------------------------------------------------------   � ��� � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -� ��� l     ������  � $  Hexadecimal number conversion   � ��� <   H e x a d e c i m a l   n u m b e r   c o n v e r s i o n� ��� l     ��������  ��  ��  � ��� i  � ���� I     �� 
�� .Mth:NuHenull���     long  o      ���� 0 	thenumber 	theNumber ��
�� 
Plac |��������  ��   o      ���� 0 padsize padSize��   l     ���� m      ����  ��  ��   ����
�� 
Pref |������	��  ��   o      ���� 0 	hasprefix 	hasPrefix��  	 l     
����
 m      ��
�� boovtrue��  ��  ��  � l    � Q     � k    �  r     n    I    ������ (0 asintegerparameter asIntegerParameter  o    	���� 0 	thenumber 	theNumber �� m   	 
 �  ��  ��   o    ���� 0 _support   o      ���� 0 	thenumber 	theNumber  r     !  n   "#" I    ��$���� (0 asintegerparameter asIntegerParameter$ %&% o    ���� 0 padsize padSize& '��' m    (( �))  p a d d i n g   t o��  ��  # o    ���� 0 _support  ! o      ���� 0 padsize padSize *+* r    ,,-, n   *./. I   $ *��0���� (0 asbooleanparameter asBooleanParameter0 121 o   $ %���� 0 	hasprefix 	hasPrefix2 3��3 m   % &44 �55  p r e f i x��  ��  / o    $���� 0 _support  - o      ���� 0 	hasprefix 	hasPrefix+ 676 r   - 0898 m   - .:: �;;  9 o      ���� 0 hextext hexText7 <=< Z   1 E>?��@> A   1 4ABA o   1 2���� 0 	thenumber 	theNumberB m   2 3����  ? k   7 ?CC DED r   7 :FGF m   7 8HH �II  -G o      ���� 0 	hexprefix 	hexPrefixE J��J r   ; ?KLK d   ; =MM o   ; <���� 0 	thenumber 	theNumberL o      ���� 0 	thenumber 	theNumber��  ��  @ r   B ENON m   B CPP �QQ  O o      ���� 0 	hexprefix 	hexPrefix= RSR Z  F STU����T o   F G���� 0 	hasprefix 	hasPrefixU r   J OVWV b   J MXYX o   J K���� 0 	hexprefix 	hexPrefixY m   K LZZ �[[  0 xW o      ���� 0 	hexprefix 	hexPrefix��  ��  S \]\ V   T s^_^ k   \ n`` aba r   \ hcdc b   \ fefe l  \ dg����g n   \ dhih 4   ] d��j
�� 
cobjj l  ^ ck����k [   ^ clml `   ^ anon o   ^ _���� 0 	thenumber 	theNumbero m   _ `���� m m   a b���� ��  ��  i m   \ ]pp �qq   0 1 2 3 4 5 6 7 8 9 A B C D E F��  ��  f o   d e���� 0 hextext hexTextd o      ���� 0 hextext hexTextb r��r r   i nsts _   i luvu o   i j���� 0 	thenumber 	theNumberv m   j k���� t o      ���� 0 	thenumber 	theNumber��  _ ?   X [wxw o   X Y���� 0 	thenumber 	theNumberx m   Y Z��  ] yzy V   t �{|{ r   ~ �}~} b   ~ �� m   ~ �� ���  0� o    ��~�~ 0 hextext hexText~ o      �}�} 0 hextext hexText| A   x }��� n   x {��� 1   y {�|
�| 
leng� o   x y�{�{ 0 hextext hexText� o   { |�z�z 0 padsize padSizez ��y� L   � ��� b   � ���� o   � ��x�x 0 	hexprefix 	hexPrefix� o   � ��w�w 0 hextext hexText�y   R      �v��
�v .ascrerr ****      � ****� o      �u�u 0 etext eText� �t��
�t 
errn� o      �s�s 0 enumber eNumber� �r��
�r 
erob� o      �q�q 0 efrom eFrom� �p��o
�p 
errt� o      �n�n 
0 eto eTo�o   I   � ��m��l�m 
0 _error  � ��� m   � ��� ��� 2 f o r m a t   h e x a d e c i m a l   n u m b e r� ��� o   � ��k�k 0 etext eText� ��� o   � ��j�j 0 enumber eNumber� ��� o   � ��i�i 0 efrom eFrom� ��h� o   � ��g�g 
0 eto eTo�h  �l   � � TO DO: `padding to` is not an ideal name (OTOH, `using padding` sounds awkward, while `with padding` would likely cause confusion as standard `with`/`without` keywords may already be used with boolean `prefix` parameters)    ����   T O   D O :   ` p a d d i n g   t o `   i s   n o t   a n   i d e a l   n a m e   ( O T O H ,   ` u s i n g   p a d d i n g `   s o u n d s   a w k w a r d ,   w h i l e   ` w i t h   p a d d i n g `   w o u l d   l i k e l y   c a u s e   c o n f u s i o n   a s   s t a n d a r d   ` w i t h ` / ` w i t h o u t `   k e y w o r d s   m a y   a l r e a d y   b e   u s e d   w i t h   b o o l e a n   ` p r e f i x `   p a r a m e t e r s )� ��� l     �f�e�d�f  �e  �d  � ��� l     �c�b�a�c  �b  �a  � ��� i  � ���� I     �`��
�` .Mth:HeNunull���     ctxt� o      �_�_ 0 hextext hexText� �^��]
�^ 
Prec� |�\�[��Z��\  �[  � o      �Y�Y 0 	isprecise 	isPrecise�Z  � l     ��X�W� m      �V
�V boovtrue�X  �W  �]  � Q    ���� P    ����� k    ��� ��� r    ��� n   ��� I    �U��T�U "0 astextparameter asTextParameter� ��� o    �S�S 0 hextext hexText� ��R� m    �� ���  �R  �T  � o    �Q�Q 0 _support  � o      �P�P 0 hextext hexText� ��� r    #��� n   !��� I    !�O��N�O (0 asbooleanparameter asBooleanParameter� ��� o    �M�M 0 	isprecise 	isPrecise� ��L� m    �� ���  f u l l   p r e c i s i o n�L  �N  � o    �K�K 0 _support  � o      �J�J 0 	isprecise 	isPrecise� ��� Q   $ ����� k   ' ��� ��� r   ' *��� m   ' (�I�I  � o      �H�H 0 	thenumber 	theNumber� ��� r   + 0��� C   + .��� o   + ,�G�G 0 hextext hexText� m   , -�� ���  -� o      �F�F 0 
isnegative 
isNegative� ��� Z  1 F���E�D� o   1 2�C�C 0 
isnegative 
isNegative� r   5 B��� n   5 @��� 7  6 @�B��
�B 
ctxt� m   : <�A�A � m   = ?�@�@��� o   5 6�?�? 0 hextext hexText� o      �>�> 0 hextext hexText�E  �D  � ��� Z  G ^���=�<� C   G J��� o   G H�;�; 0 hextext hexText� m   H I�� ���  0 x� r   M Z��� n   M X��� 7  N X�:��
�: 
ctxt� m   R T�9�9 � m   U W�8�8��� o   M N�7�7 0 hextext hexText� o      �6�6 0 hextext hexText�=  �<  � ��5� X   _ ���4�� k   o ��� ��� r   o t��� ]   o r��� o   o p�3�3 0 	thenumber 	theNumber� m   p q�2�2 � o      �1�1 0 	thenumber 	theNumber�    r   u � I  u ��0 z�/�.
�/ .sysooffslong    ��� null
�. misccura�0   �-
�- 
psof o   { |�,�, 0 charref charRef �+�*
�+ 
psin m   } �		 �

   0 1 2 3 4 5 6 7 8 9 A B C D E F�*   o      �)�) 0 i    Z  � ��(�' =   � � o   � ��&�& 0 i   m   � ��%�%   R   � ��$�#�"
�$ .ascrerr ****      � ****�#  �"  �(  �'   �! r   � � \   � � [   � � o   � �� �  0 	thenumber 	theNumber o   � ��� 0 i   m   � ���  o      �� 0 	thenumber 	theNumber�!  �4 0 charref charRef� o   b c�� 0 hextext hexText�5  � R      ���
� .ascrerr ****      � ****�  �  � R   � ��
� .ascrerr ****      � **** m   � � � > N o t   a   v a l i d   h e x a d e c i m a l   n u m b e r . �
� 
errn m   � ����Y ��
� 
erob o   � ��� 0 hextext hexText�  �   Z  � �!"��! F   � �#$# o   � ��� 0 	isprecise 	isPrecise$ l  � �%��% =   � �&'& o   � ��� 0 	thenumber 	theNumber' [   � �()( o   � ��� 0 	thenumber 	theNumber) m   � ��� �  �  " R   � ��
*+
�
 .ascrerr ****      � ***** m   � �,, �-- j H e x a d e c i m a l   n u m b e r   i s   t o o   l a r g e   t o   c o n v e r t   p r e c i s e l y .+ �	./
�	 
errn. m   � ����Y/ �01
� 
erob0 o   � ��� 0 hextext hexText1 �2�
� 
errt2 m   � ��
� 
doub�  �  �    343 Z  � �56��5 o   � �� �  0 
isnegative 
isNegative6 r   � �787 d   � �99 o   � ����� 0 	thenumber 	theNumber8 o      ���� 0 	thenumber 	theNumber�  �  4 :��: L   � �;; o   � ����� 0 	thenumber 	theNumber��  � ��<
�� consdiac< ��=
�� conshyph= ��>
�� conspunc> ����
�� conswhit��  � ��?
�� conscase? ����
�� consnume��  � R      ��@A
�� .ascrerr ****      � ****@ o      ���� 0 etext eTextA ��BC
�� 
errnB o      ���� 0 enumber eNumberC ��DE
�� 
erobD o      ���� 0 efrom eFromE ��F��
�� 
errtF o      ���� 
0 eto eTo��  � I  ��G���� 
0 _error  G HIH m  	JJ �KK 0 p a r s e   h e x a d e c i m a l   n u m b e rI LML o  	
���� 0 etext eTextM NON o  
���� 0 enumber eNumberO PQP o  ���� 0 efrom eFromQ R��R o  ���� 
0 eto eTo��  ��  � STS l     ��������  ��  ��  T UVU l     ��������  ��  ��  V WXW l     ��YZ��  Y J D--------------------------------------------------------------------   Z �[[ � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -X \]\ l     ��^_��  ^ !  General numeric operations   _ �`` 6   G e n e r a l   n u m e r i c   o p e r a t i o n s] aba l     ��������  ��  ��  b cdc i  � �efe I     ��g��
�� .Mth:DeRanull���     doubg o      ���� 0 n  ��  f Q     hijh L    kk ]    
lml l   n����n c    opo o    ���� 0 n  p m    ��
�� 
doub��  ��  m l   	q����q ^    	rsr 1    ��
�� 
pi  s m    ���� ���  ��  i R      ��tu
�� .ascrerr ****      � ****t o      ���� 0 etext eTextu ��vw
�� 
errnv o      ���� 0 enumber eNumberw ��xy
�� 
erobx o      ���� 0 efrom eFromy ��z��
�� 
errtz o      ���� 
0 eto eTo��  j I    ��{���� 
0 _error  { |}| m    ~~ � $ c o n v e r t   t o   r a d i a n s} ��� o    ���� 0 etext eText� ��� o    ���� 0 enumber eNumber� ��� o    ���� 0 efrom eFrom� ���� o    ���� 
0 eto eTo��  ��  d ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� i  � ���� I     �����
�� .Mth:RaDenull���     doub� o      ���� 0 n  ��  � Q     ���� L    	�� ^    ��� o    ���� 0 n  � l   ������ ^    ��� 1    ��
�� 
pi  � m    ���� ���  ��  � R      ����
�� .ascrerr ****      � ****� o      ���� 0 etext eText� ����
�� 
errn� o      ���� 0 enumber eNumber� ����
�� 
erob� o      ���� 0 efrom eFrom� �����
�� 
errt� o      ���� 
0 eto eTo��  � I    ������� 
0 _error  � ��� m    �� ��� $ c o n v e r t   t o   d e g r e e s� ��� o    ���� 0 etext eText� ��� o    ���� 0 enumber eNumber� ��� o    ���� 0 efrom eFrom� ���� o    ���� 
0 eto eTo��  ��  � ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� i  � ���� I     �����
�� .Mth:Abs_null���     nmbr� o      ���� 0 n  ��  � Q     )���� k    �� ��� r    ��� c    ��� o    ���� 0 n  � m    ��
�� 
nmbr� o      ���� 0 n  � ���� Z   	 ������ A   	 ��� o   	 
���� 0 n  � m   
 ����  � L    �� d    �� o    ���� 0 n  ��  � L    �� o    ���� 0 n  ��  � R      ����
�� .ascrerr ****      � ****� o      ���� 0 etext eText� ����
�� 
errn� o      ���� 0 enumber eNumber� ����
�� 
erob� o      ���� 0 efrom eFrom� �����
�� 
errt� o      ���� 
0 eto eTo��  � I    )������� 
0 _error  � ��� m     !�� ���  a b s� ��� o   ! "�� 0 etext eText� ��� o   " #�~�~ 0 enumber eNumber� ��� o   # $�}�} 0 efrom eFrom� ��|� o   $ %�{�{ 
0 eto eTo�|  ��  � ��� l     �z�y�x�z  �y  �x  � ��� l     �w�v�u�w  �v  �u  � ��� i  � ���� I     �t��s
�t .Mth:CmpNnull���     ****� J      �� ��� o      �r�r 0 n1  � ��q� o      �p�p 0 n2  �q  �s  � Q     Y���� k    G�� ��� r    ��� J    �� ��� c    ��� o    �o�o 0 n1  � m    �n
�n 
doub� ��m� c    	��� o    �l�l 0 n2  � m    �k
�k 
doub�m  � J      �� ��� o      �j�j 0 n1  � ��i� o      �h�h 0 n2  �i  � ��g� Z    G� � F    2 l   $�f�e A    $ \    "	 o    �d�d 0 n1  	 o    !�c�c 0 _isequaldelta _isEqualDelta o   " #�b�b 0 n2  �f  �e   l  ' 0
�a�`
 ?   ' 0 [   ' . o   ' (�_�_ 0 n1   o   ( -�^�^ 0 _isequaldelta _isEqualDelta o   . /�]�] 0 n2  �a  �`    L   5 7 m   5 6�\�\    A   : = o   : ;�[�[ 0 n1   o   ; <�Z�Z 0 n2   �Y L   @ B m   @ A�X�X���Y   L   E G m   E F�W�W �g  � R      �V
�V .ascrerr ****      � **** o      �U�U 0 etext eText �T
�T 
errn o      �S�S 0 enumber eNumber �R
�R 
erob o      �Q�Q 0 efrom eFrom �P�O
�P 
errt o      �N�N 
0 eto eTo�O  � I   O Y�M�L�M 
0 _error     m   P Q!! �""  c m p  #$# o   Q R�K�K 0 etext eText$ %&% o   R S�J�J 0 enumber eNumber& '(' o   S T�I�I 0 efrom eFrom( )�H) o   T U�G�G 
0 eto eTo�H  �L  � *+* l     �F�E�D�F  �E  �D  + ,-, l     �C�B�A�C  �B  �A  - ./. i  � �010 I     �@2�?
�@ .Mth:MinNnull���     ****2 o      �>�> 0 thelist theList�?  1 Q     Y3453 k    G66 787 r    9:9 n   ;<; I    �==�<�= "0 aslistparameter asListParameter= >?> o    	�;�; 0 thelist theList? @�:@ m   	 
AA �BB  �:  �<  < o    �9�9 0 _support  : o      �8�8 0 thelist theList8 CDC r    EFE c    GHG l   I�7�6I n    JKJ 4   �5L
�5 
cobjL m    �4�4 K o    �3�3 0 thelist theList�7  �6  H m    �2
�2 
nmbrF o      �1�1 0 	theresult 	theResultD MNM X    DO�0PO k   * ?QQ RSR r   * 1TUT c   * /VWV n  * -XYX 1   + -�/
�/ 
pcntY o   * +�.�. 0 aref aRefW m   - .�-
�- 
nmbrU o      �,�, 0 n  S Z�+Z Z  2 ?[\�*�)[ A   2 5]^] o   2 3�(�( 0 n  ^ o   3 4�'�' 0 	theresult 	theResult\ r   8 ;_`_ o   8 9�&�& 0 n  ` o      �%�% 0 	theresult 	theResult�*  �)  �+  �0 0 aref aRefP o    �$�$ 0 thelist theListN a�#a L   E Gbb o   E F�"�" 0 	theresult 	theResult�#  4 R      �!cd
�! .ascrerr ****      � ****c o      � �  0 etext eTextd �ef
� 
errne o      �� 0 enumber eNumberf �gh
� 
erobg o      �� 0 efrom eFromh �i�
� 
errti o      �� 
0 eto eTo�  5 I   O Y�j�� 
0 _error  j klk m   P Qmm �nn  m i nl opo o   Q R�� 0 etext eTextp qrq o   R S�� 0 enumber eNumberr sts o   S T�� 0 efrom eFromt u�u o   T U�� 
0 eto eTo�  �  / vwv l     ����  �  �  w xyx l     ����  �  �  y z{z i  � �|}| I     �~�

� .Mth:MaxNnull���     ****~ o      �	�	 0 thelist theList�
  } Q     Y�� k    G�� ��� r    ��� n   ��� I    ���� "0 aslistparameter asListParameter� ��� o    	�� 0 thelist theList� ��� m   	 
�� ���  �  �  � o    �� 0 _support  � o      �� 0 thelist theList� ��� r    ��� c    ��� l   ���� n    ��� 4   � �
�  
cobj� m    ���� � o    ���� 0 thelist theList�  �  � m    ��
�� 
nmbr� o      ���� 0 	theresult 	theResult� ��� X    D����� k   * ?�� ��� r   * 1��� c   * /��� n  * -��� 1   + -��
�� 
pcnt� o   * +���� 0 aref aRef� m   - .��
�� 
nmbr� o      ���� 0 n  � ���� Z  2 ?������� ?   2 5��� o   2 3���� 0 n  � o   3 4���� 0 	theresult 	theResult� r   8 ;��� o   8 9���� 0 n  � o      ���� 0 	theresult 	theResult��  ��  ��  �� 0 aref aRef� o    ���� 0 thelist theList� ���� L   E G�� o   E F���� 0 	theresult 	theResult��  � R      ����
�� .ascrerr ****      � ****� o      ���� 0 etext eText� ����
�� 
errn� o      ���� 0 enumber eNumber� ����
�� 
erob� o      ���� 0 efrom eFrom� �����
�� 
errt� o      ���� 
0 eto eTo��  � I   O Y������� 
0 _error  � ��� m   P Q�� ���  m a x� ��� o   Q R���� 0 etext eText� ��� o   R S���� 0 enumber eNumber� ��� o   S T���� 0 efrom eFrom� ���� o   T U���� 
0 eto eTo��  ��  { ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� i  � ���� I     ����
�� .Mth:RouNnull���     doub� o      ���� 0 num  � ����
�� 
Plac� |����������  ��  � o      ���� 0 decimalplaces decimalPlaces��  � l     ������ m      ����  ��  ��  � �����
�� 
Dire� |����������  ��  � o      ���� &0 roundingdirection roundingDirection��  � l     ������ m      ��
�� MRndRNhE��  ��  ��  � k    g�� ��� l     ������  � � � TO DO: implement `rounding halves toward zero` and `rounding away from zero` for complete consistency with NSNumberFormatterRoundingMode (which is used by `format number`)   � ���X   T O   D O :   i m p l e m e n t   ` r o u n d i n g   h a l v e s   t o w a r d   z e r o `   a n d   ` r o u n d i n g   a w a y   f r o m   z e r o `   f o r   c o m p l e t e   c o n s i s t e n c y   w i t h   N S N u m b e r F o r m a t t e r R o u n d i n g M o d e   ( w h i c h   i s   u s e d   b y   ` f o r m a t   n u m b e r ` )� ���� Q    g���� k   Q�� ��� r    ��� n   ��� I    ������� "0 asrealparameter asRealParameter� ��� o    	���� 0 num  � ���� m   	 
�� ���  ��  ��  � o    ���� 0 _support  � o      ���� 0 num  � ��� r    ��� n   ��� I    ������� (0 asintegerparameter asIntegerParameter� ��� o    ���� 0 decimalplaces decimalPlaces� ���� m    �� ���  t o   p l a c e s��  ��  � o    ���� 0 _support  � o      ���� 0 decimalplaces decimalPlaces� ��� Z    8������� >    "��� o     ���� 0 decimalplaces decimalPlaces� m     !����  � k   % 4�� � � r   % * a   % ( m   % &���� 
 o   & '���� 0 decimalplaces decimalPlaces o      ���� 0 themultiplier theMultiplier  �� l  + 4 r   + 4	
	 ^   + 2 ]   + 0 ]   + . o   + ,���� 0 num   m   , -���� 
 o   . /���� 0 themultiplier theMultiplier m   0 1���� 

 o      ���� 0 num  �� multiplying and dividing by 10 before and after applying the multiplier helps avoid poor rounding results for some numbers due to inevitable loss of precision in floating-point math (e.g. `324.21 * 100 div 1 / 100` returns 324.2 but needs to be 324.21), though this hasn't been tested on all possible values for obvious reasons -- TO DO: shouldn't /10 be done after rounding is applied (in which case following calculations should use mod 10, etc)?    ��   m u l t i p l y i n g   a n d   d i v i d i n g   b y   1 0   b e f o r e   a n d   a f t e r   a p p l y i n g   t h e   m u l t i p l i e r   h e l p s   a v o i d   p o o r   r o u n d i n g   r e s u l t s   f o r   s o m e   n u m b e r s   d u e   t o   i n e v i t a b l e   l o s s   o f   p r e c i s i o n   i n   f l o a t i n g - p o i n t   m a t h   ( e . g .   ` 3 2 4 . 2 1   *   1 0 0   d i v   1   /   1 0 0 `   r e t u r n s   3 2 4 . 2   b u t   n e e d s   t o   b e   3 2 4 . 2 1 ) ,   t h o u g h   t h i s   h a s n ' t   b e e n   t e s t e d   o n   a l l   p o s s i b l e   v a l u e s   f o r   o b v i o u s   r e a s o n s   - -   T O   D O :   s h o u l d n ' t   / 1 0   b e   d o n e   a f t e r   r o u n d i n g   i s   a p p l i e d   ( i n   w h i c h   c a s e   f o l l o w i n g   c a l c u l a t i o n s   s h o u l d   u s e   m o d   1 0 ,   e t c ) ?��  ��  ��  �  l  9 9����   � � TO DO: check the following real comparisons work reliably and won't fall afoul of floating point imprecisions (might be an idea to use `cmp` or similar to allow for that; eliminating current magic math would also make this code easier to verify)    ��   T O   D O :   c h e c k   t h e   f o l l o w i n g   r e a l   c o m p a r i s o n s   w o r k   r e l i a b l y   a n d   w o n ' t   f a l l   a f o u l   o f   f l o a t i n g   p o i n t   i m p r e c i s i o n s   ( m i g h t   b e   a n   i d e a   t o   u s e   ` c m p `   o r   s i m i l a r   t o   a l l o w   f o r   t h a t ;   e l i m i n a t i n g   c u r r e n t   m a g i c   m a t h   w o u l d   a l s o   m a k e   t h i s   c o d e   e a s i e r   t o   v e r i f y )  Z   92 =  9 < o   9 :���� &0 roundingdirection roundingDirection l  : ;���� m   : ;��
�� MRndRNhE��  ��   Z   ? m !"#  E  ? K$%$ J   ? C&& '(' m   ? @)) ��      ( *��* m   @ A++ ?�      ��  % J   C J,, -��- `   C H./. l  C F0����0 ^   C F121 o   C D���� 0 num  2 m   D E���� ��  ��  / m   F G���� ��  ! l  N S3453 r   N S676 _   N Q898 o   N O���� 0 num  9 m   O P���� 7 o      ���� 0 num  4 T N if num ends in .5 and its div is even then round toward zero so it stays even   5 �:: �   i f   n u m   e n d s   i n   . 5   a n d   i t s   d i v   i s   e v e n   t h e n   r o u n d   t o w a r d   z e r o   s o   i t   s t a y s   e v e n" ;<; ?   V Y=>= o   V W���� 0 num  > m   W X����  < ?��? l  \ c@AB@ r   \ cCDC _   \ aEFE l  \ _G����G [   \ _HIH o   \ ]���� 0 num  I m   ] ^JJ ?�      ��  ��  F m   _ `���� D o      ���� 0 num  A H B else round to nearest whole digit (.5 will round up if positive�)   B �KK �   e l s e   r o u n d   t o   n e a r e s t   w h o l e   d i g i t   ( . 5   w i l l   r o u n d   u p   i f   p o s i t i v e & )��  # l  f mLMNL r   f mOPO _   f kQRQ l  f iS����S \   f iTUT o   f g���� 0 num  U m   g hVV ?�      ��  ��  R m   i j���� P o      ���� 0 num  M 4 . (�or down if negative to give an even result)   N �WW \   ( & o r   d o w n   i f   n e g a t i v e   t o   g i v e   a n   e v e n   r e s u l t ) XYX =  p sZ[Z o   p q���� &0 roundingdirection roundingDirection[ l  q r\����\ m   q r��
�� MRndRNhT��  ��  Y ]^] Z   v �_`ab_ E  v �cdc J   v zee fgf m   v whh ��      g i��i m   w xjj ?�      ��  d J   z kk l��l `   z }mnm o   z {���� 0 num  n m   { |���� ��  ` l  � �opqo r   � �rsr _   � �tut o   � ����� 0 num  u m   � ����� s o      ���� 0 num  p 0 * if num ends in .5 then round towards zero   q �vv T   i f   n u m   e n d s   i n   . 5   t h e n   r o u n d   t o w a r d s   z e r oa wxw ?   � �yzy o   � ����� 0 num  z m   � �����  x {�{ l  � �|}~| r   � �� _   � ���� l  � ���~�}� [   � ���� o   � ��|�| 0 num  � m   � ��� ?�      �~  �}  � m   � ��{�{ � o      �z�z 0 num  } ( " else round to nearest whole digit   ~ ��� D   e l s e   r o u n d   t o   n e a r e s t   w h o l e   d i g i t�  b r   � ���� _   � ���� l  � ���y�x� \   � ���� o   � ��w�w 0 num  � m   � ��� ?�      �y  �x  � m   � ��v�v � o      �u�u 0 num  ^ ��� =  � ���� o   � ��t�t &0 roundingdirection roundingDirection� l  � ���s�r� m   � ��q
�q MRndRNhF�s  �r  � ��� R   � ��p��o
�p .ascrerr ****      � ****� m   � ��� ���  T O D O�o  � ��� =  � ���� o   � ��n�n &0 roundingdirection roundingDirection� l  � ���m�l� m   � ��k
�k MRndRN_T�m  �l  � ��� r   � ���� _   � ���� o   � ��j�j 0 num  � m   � ��i�i � o      �h�h 0 num  � ��� =  � ���� o   � ��g�g &0 roundingdirection roundingDirection� l  � ���f�e� m   � ��d
�d MRndRN_F�f  �e  � ��� R   � ��c��b
�c .ascrerr ****      � ****� m   � ��� ���  T O D O�b  � ��� =  � ���� o   � ��a�a &0 roundingdirection roundingDirection� l  � ���`�_� m   � ��^
�^ MRndRN_U�`  �_  � ��� l  � ����� Z   � ����]�� G   � ���� A   � ���� o   � ��\�\ 0 num  � m   � ��[�[  � =   � ���� `   � ���� o   � ��Z�Z 0 num  � m   � ��Y�Y � m   � ��X�X  � r   � ���� _   � ���� o   � ��W�W 0 num  � m   � ��V�V � o      �U�U 0 num  �]  � r   � ���� _   � ���� l  � ���T�S� [   � ���� o   � ��R�R 0 num  � m   � ��Q�Q �T  �S  � m   � ��P�P � o      �O�O 0 num  �   ceil()   � ���    c e i l ( )� ��� =  � ���� o   � ��N�N &0 roundingdirection roundingDirection� l  � ���M�L� m   � ��K
�K MRndRN_D�M  �L  � ��J� l "���� Z  "���I�� G  ��� ?  ��� o  �H�H 0 num  � m  �G�G  � =  ��� `  
��� o  �F�F 0 num  � m  	�E�E � m  
�D�D  � r  ��� _  ��� o  �C�C 0 num  � m  �B�B � o      �A�A 0 num  �I  � r  "��� _   ��� l ��@�?� \  ��� o  �>�> 0 num  � m  �=�= �@  �?  � m  �<�< � o      �;�; 0 num  �   floor()   � ���    f l o o r ( )�J   n %2��� I  *2�:��9�: >0 throwinvalidparameterconstant throwInvalidParameterConstant� ��� o  *+�8�8 &0 roundingdirection roundingDirection� ��7� m  +.�� ���  b y�7  �9  � o  %*�6�6 0 _support   ��5� Z  3Q����� =  36��� o  34�4�4 0 decimalplaces decimalPlaces� m  45�3�3  � L  9=�� _  9<   o  9:�2�2 0 num   m  :;�1�1 �  A  @C o  @A�0�0 0 decimalplaces decimalPlaces m  AB�/�/   �. L  FJ _  FI	 o  FG�-�- 0 num  	 o  GH�,�, 0 themultiplier theMultiplier�.  � L  MQ

 ^  MP o  MN�+�+ 0 num   o  NO�*�* 0 themultiplier theMultiplier�5  � R      �)
�) .ascrerr ****      � **** o      �(�( 0 etext eText �'
�' 
errn o      �&�& 0 enumber eNumber �%
�% 
erob o      �$�$ 0 efrom eFrom �#�"
�# 
errt o      �!�! 
0 eto eTo�"  � I  Yg� ��  
0 _error    m  Z] �  r o u n d   n u m b e r  o  ]^�� 0 etext eText  o  ^_�� 0 enumber eNumber  o  _`�� 0 efrom eFrom � o  `a�� 
0 eto eTo�  �  ��  �  !  l     ����  �  �  ! "#" l     ����  �  �  # $%$ l     �&'�  & J D--------------------------------------------------------------------   ' �(( � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -% )*) l     �+,�  +   Trigonometry   , �--    T r i g o n o m e t r y* ./. l     ����  �  �  / 010 i  � �232 I      �4�� 0 _sin  4 5�5 o      �� 0 x  �  �  3 k    66 787 Z     +9:�
�	9 =    ;<; `     =>= o     �� 0 x  > m    �� < m    ��  : l   '?@A? k    'BB CDC Z   EF��E A    GHG o    	�� 0 x  H m   	 
��  F r    IJI d    KK o    �� 0 x  J o      � �  0 x  �  �  D L��L L    'MM n   &NON 4    %��P
�� 
cobjP l   $Q����Q [    $RSR _    "TUT `     VWV o    ���� 0 x  W m    ����hU m     !���� S m   " #���� ��  ��  O o    ���� 0 _precalcsine _precalcSine��  @ 1 + performance optimisation for common values   A �XX V   p e r f o r m a n c e   o p t i m i s a t i o n   f o r   c o m m o n   v a l u e s�
  �	  8 YZY l  , 5[\][ r   , 5^_^ ^   , 3`a` ]   , 1bcb `   , /ded o   , -���� 0 x  e m   - .����hc 1   / 0��
�� 
pi  a m   1 2���� �_ o      ���� 0 x  \ &   convert from degrees to radians   ] �ff @   c o n v e r t   f r o m   d e g r e e s   t o   r a d i a n sZ ghg r   6 ;iji A   6 9klk o   6 7���� 0 x  l m   7 8����  j o      ���� 0 isneg isNegh mnm Z  < Hop����o o   < =���� 0 isneg isNegp r   @ Dqrq d   @ Bss o   @ A���� 0 x  r o      ���� 0 x  ��  ��  n tut r   I Rvwv _   I Pxyx l  I Nz����z ]   I N{|{ o   I J���� 0 x  | l  J M}����} ^   J M~~ m   J K����  1   K L��
�� 
pi  ��  ��  ��  ��  y m   N O���� w o      ���� 0 y  u ��� r   S ^��� \   S \��� o   S T���� 0 y  � ]   T [��� l  T Y������ _   T Y��� ]   T W��� o   T U���� 0 y  � m   U V�� ?�      � m   W X���� ��  ��  � m   Y Z���� � o      ���� 0 z  � ��� Z   _ v������� =  _ d��� `   _ b��� o   _ `���� 0 z  � m   ` a���� � m   b c���� � k   g r�� ��� r   g l��� [   g j��� o   g h���� 0 z  � m   h i���� � o      ���� 0 z  � ���� r   m r��� [   m p��� o   m n���� 0 y  � m   n o���� � o      ���� 0 y  ��  ��  ��  � ��� r   w |��� `   w z��� o   w x���� 0 z  � m   x y���� � o      ���� 0 z  � ��� Z   } �������� ?   } ���� o   } ~���� 0 z  � m   ~ ���� � k   � ��� ��� r   � ���� H   � ��� o   � ����� 0 isneg isNeg� o      ���� 0 isneg isNeg� ���� r   � ���� \   � ���� o   � ����� 0 z  � m   � ����� � o      ���� 0 z  ��  ��  ��  � ��� r   � ���� \   � ���� l  � ������� \   � ���� l  � ������� \   � ���� o   � ����� 0 x  � ]   � ���� o   � ����� 0 y  � m   � ��� ?�!�?��v��  ��  � ]   � ���� o   � ����� 0 y  � m   � ��� >dD,���J��  ��  � ]   � ���� o   � ����� 0 y  � m   � ��� <�F���P�� o      ���� 0 z2  � ��� r   � ���� ]   � ���� o   � ����� 0 z2  � o   � ����� 0 z2  � o      ���� 0 zz  � ��� Z   ������� G   � ���� =  � ���� o   � ����� 0 z  � m   � ����� � =  � ���� o   � ����� 0 z  � m   � ����� � r   � ���� [   � ���� \   � ���� m   � ��� ?�      � ^   � ���� o   � ����� 0 zz  � m   � ����� � ]   � ���� ]   � ���� o   � ����� 0 zz  � o   � ����� 0 zz  � l  � ������� [   � ���� ]   � ���� l  � ������� \   � ���� ]   � ���� l  � ������� [   � ���� ]   � ���� l  � ������� \   � ���� ]   � ���� l  � �	 ����	  [   � �			 ]   � �			 m   � �		 ���I���	 o   � ����� 0 zz  	 m   � �		 >!�{N>���  ��  � o   � ����� 0 zz  � m   � �		 >�~O~�K���  ��  � o   � ����� 0 zz  � m   � �		 >���D���  ��  � o   � ����� 0 zz  � m   � �				 ?V�l�=���  ��  � o   � ����� 0 zz  � m   � �	
	
 ?�UUUV���  ��  � o      ���� 0 y  ��  � r   �			 [   �				 o   � ����� 0 z2  	 ]   �			 ]   � �			 o   � ����� 0 z2  	 o   � ����� 0 zz  	 l  �	����	 \   �			 ]   �			 l  �	����	 [   �			 ]   � �			 l  � �	����	 \   � �			 ]   � �	 	!	  l  � �	"����	" [   � �	#	$	# ]   � �	%	&	% l  � �	'����	' \   � �	(	)	( ]   � �	*	+	* m   � �	,	, =���ќ�	+ o   � ����� 0 zz  	) m   � �	-	- >Z��)[��  ��  	& o   � ����� 0 zz  	$ m   � �	.	. >��V}H���  ��  	! o   � ����� 0 zz  	 m   � �	/	/ ?*������  ��  	 o   � ����� 0 zz  	 m   � 	0	0 ?�"w��  ��  	 o  ���� 0 zz  	 m  	1	1 ?�UUUU�?��  ��  	 o      ���� 0 y  � 	2	3	2 Z 	4	5����	4 o  ���� 0 isneg isNeg	5 r  	6	7	6 d  	8	8 o  ���� 0 y  	7 o      ���� 0 y  ��  ��  	3 	9��	9 L  	:	: o  ���� 0 y  ��  1 	;	<	; l     �������  ��  �  	< 	=	>	= l     �~�}�|�~  �}  �|  	> 	?	@	? l     �{�z�y�{  �z  �y  	@ 	A	B	A i  � �	C	D	C I     �x	E�w
�x .Mth:Sin_null���     doub	E o      �v�v 0 n  �w  	D Q     	F	G	H	F L    	I	I I    �u	J�t�u 0 _sin  	J 	K�s	K c    	L	M	L o    �r�r 0 x  	M m    �q
�q 
nmbr�s  �t  	G R      �p	N	O
�p .ascrerr ****      � ****	N o      �o�o 0 etext eText	O �n	P	Q
�n 
errn	P o      �m�m 0 enumber eNumber	Q �l	R	S
�l 
erob	R o      �k�k 0 efrom eFrom	S �j	T�i
�j 
errt	T o      �h�h 
0 eto eTo�i  	H I    �g	U�f�g 
0 _error  	U 	V	W	V m    	X	X �	Y	Y  s i n	W 	Z	[	Z o    �e�e 0 etext eText	[ 	\	]	\ o    �d�d 0 enumber eNumber	] 	^	_	^ o    �c�c 0 efrom eFrom	_ 	`�b	` o    �a�a 
0 eto eTo�b  �f  	B 	a	b	a l     �`�_�^�`  �_  �^  	b 	c	d	c l     �]�\�[�]  �\  �[  	d 	e	f	e i  � �	g	h	g I     �Z	i�Y
�Z .Mth:Cos_null���     doub	i o      �X�X 0 n  �Y  	h Q      	j	k	l	j L    	m	m I    �W	n�V�W 0 _sin  	n 	o�U	o [    		p	q	p l   	r�T�S	r c    	s	t	s o    �R�R 0 n  	t m    �Q
�Q 
nmbr�T  �S  	q m    �P�P Z�U  �V  	k R      �O	u	v
�O .ascrerr ****      � ****	u o      �N�N 0 etext eText	v �M	w	x
�M 
errn	w o      �L�L 0 enumber eNumber	x �K	y	z
�K 
erob	y o      �J�J 0 efrom eFrom	z �I	{�H
�I 
errt	{ o      �G�G 
0 eto eTo�H  	l I     �F	|�E�F 
0 _error  	| 	}	~	} m    		 �	�	�  c o s	~ 	�	�	� o    �D�D 0 etext eText	� 	�	�	� o    �C�C 0 enumber eNumber	� 	�	�	� o    �B�B 0 efrom eFrom	� 	��A	� o    �@�@ 
0 eto eTo�A  �E  	f 	�	�	� l     �?�>�=�?  �>  �=  	� 	�	�	� l     �<�;�:�<  �;  �:  	� 	�	�	� i  � �	�	�	� I     �9	��8
�9 .Mth:Tan_null���     doub	� o      �7�7 0 n  �8  	� Q    4	�	�	�	� k   	�	� 	�	�	� r    	�	�	� c    	�	�	� o    �6�6 0 n  	� m    �5
�5 
nmbr	� o      �4�4 0 x  	� 	�	�	� Z   	 O	�	��3�2	� =  	 	�	�	� `   	 	�	�	� o   	 
�1�1 0 x  	� m   
 �0�0 	� m    �/�/  	� l   K	�	�	�	� k    K	�	� 	�	�	� Z   	�	��.�-	� A    	�	�	� o    �,�, 0 x  	� m    �+�+  	� r    	�	�	� d    	�	� o    �*�* 0 x  	� o      �)�) 0 x  �.  �-  	� 	�	�	� Z    :	�	��(�'	� G     +	�	�	� =    #	�	�	� o     !�&�& 0 x  	� m   ! "�%�% Z	� =  & )	�	�	� o   & '�$�$ 0 x  	� m   ' (�#�#	� R   . 6�"	�	�
�" .ascrerr ****      � ****	� m   4 5	�	� �	�	� F I n v a l i d   n u m b e r   ( r e s u l t   w o u l d   b e  " ) .	� �!	�	�
�! 
errn	� m   0 1� � �Y	� �	��
� 
erob	� o   2 3�� 0 x  �  �(  �'  	� 	��	� L   ; K	�	� n  ; J	�	�	� 4   @ I�	�
� 
cobj	� l  A H	���	� [   A H	�	�	� _   A F	�	�	� `   A D	�	�	� o   A B�� 0 x  	� m   B C��h	� m   D E�� 	� m   F G�� �  �  	� o   ; @�� "0 _precalctangent _precalcTangent�  	� 1 + performance optimisation for common values   	� �	�	� V   p e r f o r m a n c e   o p t i m i s a t i o n   f o r   c o m m o n   v a l u e s�3  �2  	� 	�	�	� l  P Y	�	�	�	� r   P Y	�	�	� ^   P W	�	�	� ]   P U	�	�	� `   P S	�	�	� o   P Q�� 0 x  	� m   Q R��h	� 1   S T�
� 
pi  	� m   U V�� �	� o      �� 0 x  	� &   convert from degrees to radians   	� �	�	� @   c o n v e r t   f r o m   d e g r e e s   t o   r a d i a n s	� 	�	�	� r   Z _	�	�	� A   Z ]	�	�	� o   Z [�� 0 x  	� m   [ \��  	� o      �� 0 isneg isNeg	� 	�	�	� Z  ` l	�	���
	� o   ` a�	�	 0 isneg isNeg	� r   d h	�	�	� d   d f	�	� o   d e�� 0 x  	� o      �� 0 x  �  �
  	� 	�	�	� r   m v	�	�	� _   m t	�	�	� l  m r	���	� ^   m r	�	�	� o   m n�� 0 x  	� l  n q	���	� ^   n q	�	�	� 1   n o�
� 
pi  	� m   o p� �  �  �  �  �  	� m   r s���� 	� o      ���� 0 y  	� 	�	�	� r   w �	�	�	� \   w �	�	�	� o   w x���� 0 y  	� ]   x 	�	�	� l  x }	�����	� _   x }	�	�	� ]   x {
 

  o   x y���� 0 y  
 m   y z

 ?�      	� m   { |���� ��  ��  	� m   } ~���� 	� o      ���� 0 z  	� 


 Z   � �

����
 =  � �


 `   � �
	


	 o   � ����� 0 z  

 m   � ����� 
 m   � ����� 
 k   � �

 


 r   � �


 [   � �


 o   � ����� 0 z  
 m   � ����� 
 o      ���� 0 z  
 
��
 r   � �


 [   � �


 o   � ����� 0 y  
 m   � ����� 
 o      ���� 0 y  ��  ��  ��  
 


 r   � �


 \   � �


 l  � �
����
 \   � �


 l  � �
 ����
  \   � �
!
"
! o   � ����� 0 x  
" ]   � �
#
$
# o   � ����� 0 y  
$ m   � �
%
% ?�!�P M��  ��  
 ]   � �
&
'
& o   � ����� 0 y  
' m   � �
(
( >A�`  ��  ��  
 ]   � �
)
*
) o   � ����� 0 y  
* m   � �
+
+ <��&3\
 o      ���� 0 z2  
 
,
-
, r   � �
.
/
. ]   � �
0
1
0 o   � ����� 0 z2  
1 o   � ����� 0 z2  
/ o      ���� 0 zz  
- 
2
3
2 Z   � �
4
5��
6
4 ?   � �
7
8
7 o   � ����� 0 zz  
8 m   � �
9
9 =����+�
5 r   � �
:
;
: [   � �
<
=
< o   � ����� 0 z2  
= ^   � �
>
?
> ]   � �
@
A
@ ]   � �
B
C
B o   � ����� 0 z2  
C o   � ����� 0 zz  
A l  � �
D����
D \   � �
E
F
E ]   � �
G
H
G l  � �
I����
I [   � �
J
K
J ]   � �
L
M
L m   � �
N
N �ɒ��O?D
M o   � ����� 0 zz  
K m   � �
O
O A1�������  ��  
H o   � ����� 0 zz  
F m   � �
P
P Aq��)�y��  ��  
? l  � �
Q����
Q \   � �
R
S
R ]   � �
T
U
T l  � �
V����
V [   � �
W
X
W ]   � �
Y
Z
Y l  � �
[����
[ \   � �
\
]
\ ]   � �
^
_
^ l  � �
`����
` [   � �
a
b
a o   � ����� 0 zz  
b m   � �
c
c @ʸ��et��  ��  
_ o   � ����� 0 zz  
] m   � �
d
d A4'�X*����  ��  
Z o   � ����� 0 zz  
X m   � �
e
e Awُ������  ��  
U o   � ����� 0 zz  
S m   � �
f
f A���<�Z6��  ��  
; o      ���� 0 y  ��  
6 r   � �
g
h
g o   � ����� 0 z2  
h o      ���� 0 y  
3 
i
j
i Z  �
k
l����
k G   �
m
n
m =  � �
o
p
o o   � ����� 0 z  
p m   � ����� 
n =  � 
q
r
q o   � ����� 0 z  
r m   � ����� 
l r  

s
t
s ^  
u
v
u m  ������
v o  ���� 0 y  
t o      ���� 0 y  ��  ��  
j 
w
x
w Z 
y
z����
y o  ���� 0 isneg isNeg
z r  
{
|
{ d  
}
} o  ���� 0 y  
| o      ���� 0 y  ��  ��  
x 
~��
~ L  

 o  ���� 0 y  ��  	� R      ��
�
�
�� .ascrerr ****      � ****
� o      ���� 0 etext eText
� ��
�
�
�� 
errn
� o      ���� 0 enumber eNumber
� ��
�
�
�� 
erob
� o      ���� 0 efrom eFrom
� ��
���
�� 
errt
� o      ���� 
0 eto eTo��  	� I  &4��
����� 
0 _error  
� 
�
�
� m  '*
�
� �
�
�  t a n
� 
�
�
� o  *+���� 0 etext eText
� 
�
�
� o  +,���� 0 enumber eNumber
� 
�
�
� o  ,-���� 0 efrom eFrom
� 
���
� o  -.���� 
0 eto eTo��  ��  	� 
�
�
� l     ��������  ��  ��  
� 
�
�
� l     ��������  ��  ��  
� 
�
�
� l     ��
�
���  
�  -----   
� �
�
� 
 - - - - -
� 
�
�
� l     ��
�
���  
�   inverse   
� �
�
�    i n v e r s e
� 
�
�
� l     ��������  ��  ��  
� 
�
�
� i  � �
�
�
� I      ��
����� 	0 _asin  
� 
���
� o      ���� 0 n  ��  ��  
� k     �
�
� 
�
�
� r     
�
�
� A     
�
�
� o     ���� 0 x  
� m    ����  
� o      ���� 0 isneg isNeg
� 
�
�
� Z   
�
�����
� o    ���� 0 isneg isNeg
� r   
 
�
�
� d   
 
�
� o   
 ���� 0 x  
� o      ���� 0 x  ��  ��  
� 
�
�
� Z   %
�
�����
� ?    
�
�
� o    ���� 0 x  
� m    ���� 
� R    !��
�
�
�� .ascrerr ****      � ****
� m     
�
� �
�
� T I n v a l i d   n u m b e r   ( n o t   b e t w e e n   - 1 . 0   a n d   1 . 0 ) .
� ��
�
�
�� 
errn
� m    �����Y
� ��
���
�� 
erob
� o    ���� 0 x  ��  ��  ��  
� 
�
�
� Z   & �
�
�
�
�
� ?   & )
�
�
� o   & '���� 0 x  
� m   ' (
�
� ?�      
� k   , 
�
� 
�
�
� r   , 1
�
�
� \   , /
�
�
� m   , -���� 
� o   - .���� 0 x  
� o      ���� 0 zz  
� 
�
�
� r   2 W
�
�
� ^   2 U
�
�
� ]   2 E
�
�
� o   2 3�� 0 zz  
� l  3 D
��~�}
� [   3 D
�
�
� ]   3 B
�
�
� l  3 @
��|�{
� \   3 @
�
�
� ]   3 >
�
�
� l  3 <
��z�y
� [   3 <
�
�
� ]   3 :
�
�
� l  3 8
��x�w
� \   3 8
�
�
� ]   3 6
�
�
� m   3 4
�
� ?hOØ��
� o   4 5�v�v 0 zz  
� m   6 7
�
� ?��Y�,��x  �w  
� o   8 9�u�u 0 zz  
� m   : ;
�
� @����?��z  �y  
� o   < =�t�t 0 zz  
� m   > ?
�
� @9����"�|  �{  
� o   @ A�s�s 0 zz  
� m   B C
�
� @<�b@���~  �}  
� l  E T
��r�q
� [   E T
�
�
� ]   E R
�
�
� l  E P
��p�o
� \   E P
�
�
� ]   E N
�
�
� l  E L
��n�m
� [   E L   ]   E J l  E H�l�k \   E H o   E F�j�j 0 zz   m   F G @5򢶿]R�l  �k   o   H I�i�i 0 zz   m   J K @bb�j1�n  �m  
� o   L M�h�h 0 zz  
� m   N O		 @w���c��p  �o  
� o   P Q�g�g 0 zz  
� m   R S

 @ug	��D��r  �q  
� o      �f�f 0 p  
�  r   X _ a   X ] l  X [�e�d [   X [ o   X Y�c�c 0 zz   o   Y Z�b�b 0 zz  �e  �d   m   [ \ ?�       o      �a�a 0 zz    r   ` i \   ` g l  ` e�`�_ ^   ` e 1   ` c�^
�^ 
pi   m   c d�]�] �`  �_   o   e f�\�\ 0 zz   o      �[�[ 0 z    r   j s !  \   j q"#" ]   j m$%$ o   j k�Z�Z 0 zz  % o   k l�Y�Y 0 p  # m   m p&& <��&3\
! o      �X�X 0 zz   '�W' r   t ()( [   t }*+* \   t w,-, o   t u�V�V 0 z  - o   u v�U�U 0 zz  + l  w |.�T�S. ^   w |/0/ 1   w z�R
�R 
pi  0 m   z {�Q�Q �T  �S  ) o      �P�P 0 z  �W  
� 121 A   � �343 o   � ��O�O 0 x  4 m   � �55 >Ey��0�:2 6�N6 r   � �787 o   � ��M�M 0 x  8 o      �L�L 0 z  �N  
� k   � �99 :;: r   � �<=< ]   � �>?> o   � ��K�K 0 x  ? o   � ��J�J 0 x  = o      �I�I 0 zz  ; @�H@ r   � �ABA [   � �CDC ]   � �EFE ^   � �GHG ]   � �IJI o   � ��G�G 0 zz  J l  � �K�F�EK \   � �LML ]   � �NON l  � �P�D�CP [   � �QRQ ]   � �STS l  � �U�B�AU \   � �VWV ]   � �XYX l  � �Z�@�?Z [   � �[\[ ]   � �]^] l  � �_�>�=_ \   � �`a` ]   � �bcb m   � �dd ?qk��v�c o   � ��<�< 0 zz  a m   � �ee ?�CA3>M��>  �=  ^ o   � ��;�; 0 zz  \ m   � �ff @�K�/�@  �?  Y o   � ��:�: 0 zz  W m   � �gg @0C1�'���B  �A  T o   � ��9�9 0 zz  R m   � �hh @3��w���D  �C  O o   � ��8�8 0 zz  M m   � �ii @ elΰ8�F  �E  H l  � �j�7�6j \   � �klk ]   � �mnm l  � �o�5�4o [   � �pqp ]   � �rsr l  � �t�3�2t \   � �uvu ]   � �wxw l  � �y�1�0y [   � �z{z ]   � �|}| l  � �~�/�.~ \   � �� o   � ��-�- 0 zz  � m   � ��� @-{Y^��/  �.  } o   � ��,�, 0 zz  { m   � ��� @Q��%��6�1  �0  x o   � ��+�+ 0 zz  v m   � ��� @be�m5v��3  �2  s o   � ��*�* 0 zz  q m   � ��� @apV�����5  �4  n o   � ��)�) 0 zz  l m   � ��� @H�"
6��7  �6  F o   � ��(�( 0 x  D o   � ��'�' 0 x  B o      �&�& 0 z  �H  
� ��� Z  � ����%�$� o   � ��#�# 0 isneg isNeg� r   � ���� d   � ��� o   � ��"�" 0 z  � o      �!�! 0 z  �%  �$  � �� � L   � ��� ^   � ���� o   � ��� 0 z  � l  � ����� ^   � ���� 1   � ��
� 
pi  � m   � ��� ��  �  �   
� ��� l     ����  �  �  � ��� l     ����  �  �  � ��� l     ����  �  �  � ��� i  ��� I     ���
� .Mth:Sinanull���     doub� o      �� 0 n  �  � Q     ���� L    �� I    ���� 	0 _asin  � ��� c    ��� o    �� 0 n  � m    �

�
 
nmbr�  �  � R      �	��
�	 .ascrerr ****      � ****� o      �� 0 etext eText� ���
� 
errn� o      �� 0 enumber eNumber� ���
� 
erob� o      �� 0 efrom eFrom� ���
� 
errt� o      �� 
0 eto eTo�  � I    � ����  
0 _error  � ��� m    �� ���  a s i n� ��� o    ���� 0 etext eText� ��� o    ���� 0 enumber eNumber� ��� o    ���� 0 efrom eFrom� ���� o    ���� 
0 eto eTo��  ��  � ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� i ��� I     �����
�� .Mth:Cosanull���     doub� o      ���� 0 n  ��  � Q      ���� L    �� \    ��� m    ���� Z� l   ������ I    ������� 	0 _asin  � ���� c    ��� o    ���� 0 n  � m    ��
�� 
nmbr��  ��  ��  ��  � R      ����
�� .ascrerr ****      � ****� o      ���� 0 etext eText� ����
�� 
errn� o      ���� 0 enumber eNumber� ����
�� 
erob� o      ���� 0 efrom eFrom� �����
�� 
errt� o      ���� 
0 eto eTo��  � I     ������� 
0 _error  � ��� m    �� ���  a c o s� ��� o    ���� 0 etext eText� ��� o    ���� 0 enumber eNumber� ��� o    ���� 0 efrom eFrom� ���� o    ���� 
0 eto eTo��  ��  � ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� i ��� I     �����
�� .Mth:Tananull���     doub� o      ���� 0 n  ��  � Q     *���� k    �� ��� r    ��� c    ��� o    ���� 0 n  � m    ��
�� 
nmbr� o      ���� 0 x  � ���� L   	 �� I   	 ������� 	0 _asin  � ���� ^   
 ��� o   
 ���� 0 x  � l   ������ a    ��� l   ������ [    ��� ]       o    ���� 0 x   o    ���� 0 x  � m    ���� ��  ��  � m     ?�      ��  ��  ��  ��  ��  � R      ��
�� .ascrerr ****      � **** o      ���� 0 etext eText ��
�� 
errn o      ���� 0 enumber eNumber ��
�� 
erob o      ���� 0 efrom eFrom ��	��
�� 
errt	 o      ���� 
0 eto eTo��  � I     *��
���� 
0 _error  
  m   ! " �  a t a n  o   " #���� 0 etext eText  o   # $���� 0 enumber eNumber  o   $ %���� 0 efrom eFrom �� o   % &���� 
0 eto eTo��  ��  �  l     ��������  ��  ��    l     ��������  ��  ��    l     ����    -----    � 
 - - - - -   l     ��!"��  !   hyperbolic   " �##    h y p e r b o l i c  $%$ l     ��������  ��  ��  % &'& i ()( I     ��*��
�� .Mth:Sinhnull���     doub* o      ���� 0 n  ��  ) Q     .+,-+ k    .. /0/ r    121 c    343 o    ���� 0 n  4 m    ��
�� 
nmbr2 o      ���� 0 x  0 5��5 L   	 66 ]   	 787 m   	 
99 ?�      8 l  
 :����: \   
 ;<; a   
 =>= o   
 ���� 	0 __e__  > o    ���� 0 x  < a    ?@? o    ���� 	0 __e__  @ d    AA o    ���� 0 x  ��  ��  ��  , R      ��BC
�� .ascrerr ****      � ****B o      ���� 0 etext eTextC ��DE
�� 
errnD o      ���� 0 enumber eNumberE ��FG
�� 
erobF o      ���� 0 efrom eFromG ��H��
�� 
errtH o      ���� 
0 eto eTo��  - I   $ .��I���� 
0 _error  I JKJ m   % &LL �MM 
 a s i n hK NON o   & '���� 0 etext eTextO PQP o   ' (���� 0 enumber eNumberQ RSR o   ( )���� 0 efrom eFromS T��T o   ) *���� 
0 eto eTo��  ��  ' UVU l     ��������  ��  ��  V WXW l     ��������  ��  ��  X YZY i [\[ I     ��]��
�� .Mth:Coshnull���     doub] o      ���� 0 n  ��  \ Q     .^_`^ k    aa bcb r    ded c    fgf o    �� 0 n  g m    �~
�~ 
nmbre o      �}�} 0 x  c h�|h L   	 ii ]   	 jkj m   	 
ll ?�      k l  
 m�{�zm [   
 non a   
 pqp o   
 �y�y 	0 __e__  q o    �x�x 0 x  o a    rsr o    �w�w 	0 __e__  s d    tt o    �v�v 0 x  �{  �z  �|  _ R      �uuv
�u .ascrerr ****      � ****u o      �t�t 0 etext eTextv �swx
�s 
errnw o      �r�r 0 enumber eNumberx �qyz
�q 
eroby o      �p�p 0 efrom eFromz �o{�n
�o 
errt{ o      �m�m 
0 eto eTo�n  ` I   $ .�l|�k�l 
0 _error  | }~} m   % & ��� 
 a c o s h~ ��� o   & '�j�j 0 etext eText� ��� o   ' (�i�i 0 enumber eNumber� ��� o   ( )�h�h 0 efrom eFrom� ��g� o   ) *�f�f 
0 eto eTo�g  �k  Z ��� l     �e�d�c�e  �d  �c  � ��� l     �b�a�`�b  �a  �`  � ��� i ��� I     �_��^
�_ .Mth:Tanhnull���     doub� o      �]�] 0 n  �^  � Q     =���� k    +�� ��� r    ��� c    ��� o    �\�\ 0 n  � m    �[
�[ 
nmbr� o      �Z�Z 0 x  � ��Y� L   	 +�� ^   	 *��� l  	 ��X�W� \   	 ��� a   	 ��� o   	 �V�V 	0 __e__  � o    �U�U 0 x  � a    ��� o    �T�T 	0 __e__  � d    �� o    �S�S 0 x  �X  �W  � l   )��R�Q� [    )��� a     ��� o    �P�P 	0 __e__  � o    �O�O 0 x  � a     (��� o     %�N�N 	0 __e__  � d   % '�� o   % &�M�M 0 x  �R  �Q  �Y  � R      �L��
�L .ascrerr ****      � ****� o      �K�K 0 etext eText� �J��
�J 
errn� o      �I�I 0 enumber eNumber� �H��
�H 
erob� o      �G�G 0 efrom eFrom� �F��E
�F 
errt� o      �D�D 
0 eto eTo�E  � I   3 =�C��B�C 
0 _error  � ��� m   4 5�� ��� 
 a t a n h� ��� o   5 6�A�A 0 etext eText� ��� o   6 7�@�@ 0 enumber eNumber� ��� o   7 8�?�? 0 efrom eFrom� ��>� o   8 9�=�= 
0 eto eTo�>  �B  � ��� l     �<�;�:�<  �;  �:  � ��� l     �9�8�7�9  �8  �7  � ��� l     �6���6  � J D--------------------------------------------------------------------   � ��� � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -� ��� l     �5���5  �   Logarithms   � ���    L o g a r i t h m s� ��� l     �4�3�2�4  �3  �2  � ��� i ��� I      �1��0�1 
0 _frexp  � ��/� o      �.�. 0 m  �/  �0  � k     n�� ��� Z    ���-�,� =    ��� o     �+�+ 0 m  � m    �*�*  � L    �� J    
�� ��� m    ��         � ��)� m    �(�(  �)  �-  �,  � ��� r    ��� A    ��� o    �'�' 0 m  � m    �&�&  � o      �%�% 0 isneg isNeg� ��� Z   "���$�#� o    �"�" 0 isneg isNeg� r    ��� d    �� o    �!�! 0 m  � o      � �  0 m  �$  �#  � ��� r   # &��� m   # $��  � o      �� 0 e  � ��� W   ' [��� Z   7 V����� @   7 :��� o   7 8�� 0 m  � m   8 9�� � k   = H��    r   = B ^   = @ o   = >�� 0 m   m   > ?��  o      �� 0 m   � r   C H [   C F	
	 o   C D�� 0 e  
 m   D E��  o      �� 0 e  �  �  � k   K V  r   K P ]   K N o   K L�� 0 m   m   L M��  o      �� 0 m   � r   Q V \   Q T o   Q R�� 0 e   m   R S��  o      �� 0 e  �  � F   + 6 @   + . o   + ,�� 0 m   m   , - ?�       A   1 4 o   1 2�� 0 m   m   2 3�
�
 �  Z  \ h !�	�  o   \ ]�� 0 isneg isNeg! r   ` d"#" d   ` b$$ o   ` a�� 0 m  # o      �� 0 m  �	  �   %�% L   i n&& J   i m'' ()( o   i j�� 0 m  ) *�* o   j k�� 0 e  �  �  � +,+ l     � �����   ��  ��  , -.- l     ��������  ��  ��  . /0/ i 121 I      ��3���� 	0 _logn  3 4��4 o      ���� 0 x  ��  ��  2 k    ;55 676 Z    89����8 B     :;: o     ���� 0 x  ; m    ����  9 R    ��<=
�� .ascrerr ****      � ****< m   
 >> �?? 8 I n v a l i d   n u m b e r   ( m u s t   b e   > 0 ) .= ��@��
�� 
errn@ m    	�����Y��  ��  ��  7 ABA r    &CDC I      ��E���� 
0 _frexp  E F��F o    ���� 0 x  ��  ��  D J      GG HIH o      ���� 0 x  I J��J o      ���� 0 e  ��  B KLK Z   '8MN��OM G   ' 2PQP A   ' *RSR o   ' (���� 0 e  S m   ( )������Q ?   - 0TUT o   - .���� 0 e  U m   . /���� N k   5 �VV WXW Z   5 ^YZ��[Y A   5 8\]\ o   5 6���� 0 x  ] m   6 7^^ ?栞fK�Z l  ; N_`a_ k   ; Nbb cdc r   ; @efe \   ; >ghg o   ; <���� 0 e  h m   < =���� f o      ���� 0 e  d iji r   A Fklk \   A Dmnm o   A B���� 0 x  n m   B Coo ?�      l o      ���� 0 z  j p��p r   G Nqrq [   G Lsts ]   G Juvu m   G Hww ?�      v o   H I���� 0 z  t m   J Kxx ?�      r o      ���� 0 y  ��  `   (2 ^ 0.5) / 2   a �yy    ( 2   ^   0 . 5 )   /   2��  [ k   Q ^zz {|{ r   Q V}~} \   Q T� o   Q R���� 0 x  � m   R S���� ~ o      ���� 0 z  | ���� r   W ^��� [   W \��� ]   W Z��� m   W X�� ?�      � o   X Y���� 0 x  � m   Z [�� ?�      � o      ���� 0 y  ��  X ��� r   _ d��� ^   _ b��� o   _ `���� 0 z  � o   ` a���� 0 y  � o      ���� 0 x  � ��� r   e j��� ]   e h��� o   e f���� 0 x  � o   f g���� 0 x  � o      ���� 0 z  � ��� r   k ���� ^   k ���� ]   k x��� ]   k n��� o   k l���� 0 x  � o   l m���� 0 z  � l  n w������ \   n w��� ]   n u��� l  n s������ [   n s��� ]   n q��� m   n o�� ��D=�l�� o   o p���� 0 z  � m   q r�� @0b�s{���  ��  � o   s t���� 0 z  � m   u v�� @P	"*?��  ��  � l  x ������� \   x ���� ]   x ���� l  x ������ [   x ��� ]   x }��� l  x {������ \   x {��� o   x y���� 0 z  � m   y z�� @A�C�l���  ��  � o   { |���� 0 z  � m   } ~�� @s��*�
��  ��  � o    ����� 0 z  � m   � ��� @���?;��  ��  � o      ���� 0 z  � ��� r   � ���� o   � ����� 0 e  � o      ���� 0 y  � ���� r   � ���� [   � ���� [   � ���� \   � ���� o   � ����� 0 z  � ]   � ���� o   � ����� 0 y  � m   � ��� ?+�\a�� o   � ����� 0 x  � ]   � ���� o   � ����� 0 e  � m   � ��� ?�0     � o      ���� 0 z  ��  ��  O k   �8�� ��� Z   � ������� A   � ���� o   � ����� 0 x  � m   � ��� ?栞fK�� l  � ����� k   � ��� ��� r   � ���� \   � ���� o   � ����� 0 e  � m   � ����� � o      ���� 0 e  � ���� r   � ���� \   � ���� ]   � ���� m   � ����� � o   � ����� 0 x  � m   � ����� � o      ���� 0 x  ��  �   (2 ^ 0.5) / 2   � ���    ( 2   ^   0 . 5 )   /   2��  � r   � ���� \   � ���� o   � ����� 0 x  � m   � ����� � o      ���� 0 x  � ��� r   � ���� ]   � ���� o   � ����� 0 x  � o   � ����� 0 x  � o      ���� 0 z  � ��� r   ���� ^   ���� ]   � ���� ]   � ���� o   � ����� 0 x  � o   � ����� 0 z  � l  � ������� [   � �   ]   � � l  � ����� [   � � ]   � � l  � �	����	 [   � �

 ]   � � l  � ����� [   � � ]   � � l  � ����� [   � � ]   � � m   � � ?��� o   � ����� 0 x   m   � � ?���?Vd���  ��   o   � ����� 0 x   m   � � @Һ�i���  ��   o   � ����� 0 x   m   � � @,�r�>����  ��   o   � ����� 0 x   m   � � @1�֒K�R��  ��   o   � ����� 0 x   m   � � @�c}~ݝ��  ��  � l  ����� [   �  ]   � �!"! l  � �#����# [   � �$%$ ]   � �&'& l  � �(����( [   � �)*) ]   � �+,+ l  � �-����- [   � �./. ]   � �010 l  � �2����2 [   � �343 o   � ����� 0 x  4 m   � �55 @&� �����  ��  1 o   � ����� 0 x  / m   � �66 @F�,N���  ��  , o   � ����� 0 x  * m   � �77 @T�3�&����  ��  ' o   � ����� 0 x  % m   � �88 @Q���^���  ��  " o   � ����� 0 x    m   � 99 @7 
�&5��  ��  � o      ���� 0 y  � :;: Z  <=����< >  >?> o  �� 0 e  ? m  �~�~  = r  @A@ \  BCB o  �}�} 0 y  C ]  DED o  �|�| 0 e  E m  FF ?+�\a�A o      �{�{ 0 y  ��  ��  ; GHG r  IJI \  KLK o  �z�z 0 y  L l M�y�xM ^  NON o  �w�w 0 z  O m  �v�v �y  �x  J o      �u�u 0 y  H PQP r  $RSR [  "TUT o   �t�t 0 x  U o   !�s�s 0 y  S o      �r�r 0 z  Q V�qV Z %8WX�p�oW >  %(YZY o  %&�n�n 0 e  Z m  &'�m�m  X r  +4[\[ [  +2]^] o  +,�l�l 0 z  ^ ]  ,1_`_ o  ,-�k�k 0 e  ` m  -0aa ?�0     \ o      �j�j 0 z  �p  �o  �q  L b�ib L  9;cc o  9:�h�h 0 z  �i  0 ded l     �g�f�e�g  �f  �e  e fgf l     �d�c�b�d  �c  �b  g hih l     �a�`�_�a  �`  �_  i jkj i  #lml I     �^n�]
�^ .Mth:Lognnull���     doubn o      �\�\ 0 n  �]  m Q     opqo L    rr I    �[s�Z�[ 	0 _logn  s t�Yt c    uvu o    �X�X 0 n  v m    �W
�W 
nmbr�Y  �Z  p R      �Vwx
�V .ascrerr ****      � ****w o      �U�U 0 etext eTextx �Tyz
�T 
errny o      �S�S 0 enumber eNumberz �R{|
�R 
erob{ o      �Q�Q 0 efrom eFrom| �P}�O
�P 
errt} o      �N�N 
0 eto eTo�O  q I    �M~�L�M 
0 _error  ~ � m    �� ���  l o g n� ��� o    �K�K 0 etext eText� ��� o    �J�J 0 enumber eNumber� ��� o    �I�I 0 efrom eFrom� ��H� o    �G�G 
0 eto eTo�H  �L  k ��� l     �F�E�D�F  �E  �D  � ��� l     �C�B�A�C  �B  �A  � ��� i $'��� I     �@��?
�@ .Mth:Lo10null���     doub� o      �>�> 0 n  �?  � Q     $���� l   ���� L    �� ^    ��� ]    ��� l   ��=�<� ^    ��� I    �;��:�; 	0 _logn  � ��9� c    ��� o    �8�8 0 n  � m    �7
�7 
nmbr�9  �:  � m    �� @k���T��=  �<  � m    �� @r�     � m    �� @r�    j�   correct for minor drift   � ��� 0   c o r r e c t   f o r   m i n o r   d r i f t� R      �6��
�6 .ascrerr ****      � ****� o      �5�5 0 etext eText� �4��
�4 
errn� o      �3�3 0 enumber eNumber� �2��
�2 
erob� o      �1�1 0 efrom eFrom� �0��/
�0 
errt� o      �.�. 
0 eto eTo�/  � I    $�-��,�- 
0 _error  � ��� m    �� ��� 
 l o g 1 0� ��� o    �+�+ 0 etext eText� ��� o    �*�* 0 enumber eNumber� ��� o    �)�) 0 efrom eFrom� ��(� o     �'�' 
0 eto eTo�(  �,  � ��� l     �&�%�$�&  �%  �$  � ��� l     �#�"�!�#  �"  �!  � ��� i (+��� I     � ��
�  .Mth:Logbnull���     doub� o      �� 0 n  � ���
� 
Base� o      �� 0 b  �  � Q     '���� L    �� ^    ��� I    ���� 	0 _logn  � ��� c    ��� o    �� 0 n  � m    �
� 
nmbr�  �  � l   ���� I    ���� 	0 _logn  � ��� c    ��� o    �� 0 b  � m    �
� 
nmbr�  �  �  �  � R      ���
� .ascrerr ****      � ****� o      �� 0 etext eText� ���
� 
errn� o      �� 0 enumber eNumber� ���
� 
erob� o      �
�
 0 efrom eFrom� �	��
�	 
errt� o      �� 
0 eto eTo�  � I    '���� 
0 _error  � ��� m    �� ���  l o g b� ��� o     �� 0 etext eText� ��� o     !�� 0 enumber eNumber� ��� o   ! "�� 0 efrom eFrom� ��� o   " #� �  
0 eto eTo�  �  � ��� l     ��������  ��  ��  � ���� l     ��������  ��  ��  ��       (������ h o���������������� 	
��  � &����������������������������������������������������������������������������
�� 
pimr�� 0 _support  �� 
0 _error  �� 	0 __e__  �� 0 _isequaldelta _isEqualDelta�� 0 _precalcsine _precalcSine�� "0 _precalctangent _precalcTangent�� ,0 _makenumberformatter _makeNumberFormatter�� $0 _setroundingmode _setRoundingMode��  0 _nameforformat _nameForFormat�� 60 _canonicalnumberformatter _canonicalNumberFormatter
�� .Mth:FNumnull���     nmbr
�� .Mth:PNumnull���     ctxt
�� .Mth:NuHenull���     long
�� .Mth:HeNunull���     ctxt
�� .Mth:DeRanull���     doub
�� .Mth:RaDenull���     doub
�� .Mth:Abs_null���     nmbr
�� .Mth:CmpNnull���     ****
�� .Mth:MinNnull���     ****
�� .Mth:MaxNnull���     ****
�� .Mth:RouNnull���     doub�� 0 _sin  
�� .Mth:Sin_null���     doub
�� .Mth:Cos_null���     doub
�� .Mth:Tan_null���     doub�� 	0 _asin  
�� .Mth:Sinanull���     doub
�� .Mth:Cosanull���     doub
�� .Mth:Tananull���     doub
�� .Mth:Sinhnull���     doub
�� .Mth:Coshnull���     doub
�� .Mth:Tanhnull���     doub�� 
0 _frexp  �� 	0 _logn  
�� .Mth:Lognnull���     doub
�� .Mth:Lo10null���     doub
�� .Mth:Logbnull���     doub� ����    ����
�� 
cobj    �� 
�� 
frmk��   ����
�� 
cobj    ��
�� 
osax��  �    �� /
�� 
scpt� �� 7�������� 
0 _error  �� ����   ������������ 0 handlername handlerName�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo��   ������������ 0 handlername handlerName�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo  G������ �� &0 throwcommanderror throwCommandError�� b  ࠡ����+ � ����    } � � � � � � � � � � � } � � � � � � � � � � �� ����    } � � � � ��� � � � � � } � � � � ��� � � � � �
�� 
msng
�� 
msng� ���������� ,0 _makenumberformatter _makeNumberFormatter�� �� ��    ������ 0 formatstyle formatStyle�� 0 
localecode 
localeCode��   �������� 0 formatstyle formatStyle�� 0 
localecode 
localeCode�� 0 asocformatter asocFormatter ����������������������������������������������������
�� misccura�� &0 nsnumberformatter NSNumberFormatter�� 	0 alloc  �� 0 init  
�� FNStFNS4�� D0  nsnumberformatterscientificstyle  NSNumberFormatterScientificStyle�� "0 setnumberstyle_ setNumberStyle_
�� FNStFNS0�� 40 nsnumberformatternostyle NSNumberFormatterNoStyle
�� FNStFNS1�� >0 nsnumberformatterdecimalstyle NSNumberFormatterDecimalStyle
�� FNStFNS2�� @0 nsnumberformattercurrencystyle NSNumberFormatterCurrencyStyle
�� FNStFNS3�� >0 nsnumberformatterpercentstyle NSNumberFormatterPercentStyle
�� FNStFNS5�� @0 nsnumberformatterspelloutstyle NSNumberFormatterSpellOutStyle
�� 
errn���Y
�� 
erob
�� 
errt
�� 
enum�� �� *0 asnslocaleparameter asNSLocaleParameter�� 0 
setlocale_ 
setLocale_�� ���,j+ j+ E�O��  ���,k+ Y q��  ���,k+ Y `��  ���,k+ Y O��  ���,k+ Y >��  ���,k+ Y -��  ��a ,k+ Y )a a a �a a a a O�b  �a l+ k+ O�� �������!"���� $0 _setroundingmode _setRoundingMode�� ��#�� #  ������ "0 numberformatter numberFormatter�� &0 roundingdirection roundingDirection��  ! ������ "0 numberformatter numberFormatter�� &0 roundingdirection roundingDirection" ��������������������~�}�|�{�z�y.�x
�� MRndRNhE
�� misccura�� @0 nsnumberformatterroundhalfeven NSNumberFormatterRoundHalfEven�� $0 setroundingmode_ setRoundingMode_
�� MRndRNhT�� @0 nsnumberformatterroundhalfdown NSNumberFormatterRoundHalfDown
�� MRndRNhF�� <0 nsnumberformatterroundhalfup NSNumberFormatterRoundHalfUp
�� MRndRN_T� 80 nsnumberformatterrounddown NSNumberFormatterRoundDown
�~ MRndRN_F�} 40 nsnumberformatterroundup NSNumberFormatterRoundUp
�| MRndRN_U�{ >0 nsnumberformatterroundceiling NSNumberFormatterRoundCeiling
�z MRndRN_D�y :0 nsnumberformatterroundfloor NSNumberFormatterRoundFloor�x >0 throwinvalidparameterconstant throwInvalidParameterConstant�� ���  ���,k+ Y u��  ���,k+ Y d��  ���,k+ Y S��  ���,k+ Y B��  ���,k+ Y 1��  ���,k+ Y  ��  ���,k+ Y b  �a l+ � �w8�v�u$%�t�w  0 _nameforformat _nameForFormat�v �s&�s &  �r�r 0 formatstyle formatStyle�u  $ �q�q 0 formatstyle formatStyle% �pE�oN�nW�m`�li�kqxz
�p FNStFNS0
�o FNStFNS1
�n FNStFNS2
�m FNStFNS3
�l FNStFNS4
�k FNStFNS5�t I��  �Y ?��  �Y 4��  �Y )��  �Y ��  �Y ��  �Y �%�%� �j��i�h'(�g�j 60 _canonicalnumberformatter _canonicalNumberFormatter�i  �h  ' �f�f 0 asocformatter asocFormatter( 	�e�d�c�b�a�`�_�^�]
�e misccura�d &0 nsnumberformatter NSNumberFormatter�c 	0 alloc  �b 0 init  �a D0  nsnumberformatterscientificstyle  NSNumberFormatterScientificStyle�` "0 setnumberstyle_ setNumberStyle_�_ 0 nslocale NSLocale�^ 0 systemlocale systemLocale�] 0 
setlocale_ 
setLocale_�g '��,j+ j+ E�O���,k+ O���,j+ k+ O�� �\��[�Z)*�Y
�\ .Mth:FNumnull���     nmbr�[ 0 	thenumber 	theNumber�Z �X+,
�X 
Usin+ {�W�V�U�W 0 formatstyle formatStyle�V  
�U FNStFNSD, �T-�S
�T 
Loca- {�R�Q�P�R 0 
localecode 
localeCode�Q  
�P 
msng�S  ) 	�O�N�M�L�K�J�I�H�G�O 0 	thenumber 	theNumber�N 0 formatstyle formatStyle�M 0 
localecode 
localeCode�L 0 asocformatter asocFormatter�K 0 
asocstring 
asocString�J 0 etext eText�I 0 enumber eNumber�H 0 efrom eFrom�G 
0 eto eTo* �F�E�D���C�B�A�@�?�>�=�<�;�:�9�8�7'�6�5.;�4�3
�F 
kocl
�E 
nmbr
�D .corecnte****       ****�C �B 60 throwinvalidparametertype throwInvalidParameterType
�A FNStFNSD
�@ 
pcls
�? 
long
�> FNStFNS0
�= FNStFNS4�< ,0 _makenumberformatter _makeNumberFormatter�; &0 stringfromnumber_ stringFromNumber_
�: 
msng
�9 
errn�8�Y
�7 
erob
�6 
ctxt�5 0 etext eText. �2�1/
�2 
errn�1 0 enumber eNumber/ �0�/0
�0 
erob�/ 0 efrom eFrom0 �.�-�,
�. 
errt�- 
0 eto eTo�,  �4 �3 
0 _error  �Y � s�kv��l j  b  �����+ Y hO��  ��,�  �E�Y �E�Y hO*��l+ E�O��k+ E�O��  )�a a ��a Y hO�a &W X  *a ����a + � �+L�*�)12�(
�+ .Mth:PNumnull���     ctxt�* 0 thetext theText�) �'34
�' 
Usin3 {�&�%�$�& 0 formatstyle formatStyle�%  
�$ FNStFNSD4 �#5�"
�# 
Loca5 {�!� ��! 0 
localecode 
localeCode�   
� 
msng�"  1 
����������� 0 thetext theText� 0 formatstyle formatStyle� 0 
localecode 
localeCode� 0 asocformatter asocFormatter� 0 
asocnumber 
asocNumber� $0 localeidentifier localeIdentifier� 0 etext eText� 0 enumber eNumber� 0 efrom eFrom� 
0 eto eTo2 ���rv��������
�	�������������6��� 
� 
kocl
� 
ctxt
� .corecnte****       ****� � 60 throwinvalidparametertype throwInvalidParameterType
� FNStFNSD
� FNStFNS4� ,0 _makenumberformatter _makeNumberFormatter� &0 numberfromstring_ numberFromString_
� 
msng�
 
0 locale  �	 $0 localeidentifier localeIdentifier
� 
leng
� 
errn��Y
� 
erob�  0 _nameforformat _nameForFormat
� 
****� 0 etext eText6 ����7
�� 
errn�� 0 enumber eNumber7 ����8
�� 
erob�� 0 efrom eFrom8 ������
�� 
errt�� 
0 eto eTo��  � �  
0 _error  �( � ��kv��l j  b  �����+ Y hO��  �E�Y hO*��l+ 	E�O��k+ 
E�O��  N�j+ j+ �&E�O��,j  �E�Y a �%a %E�O)a a a ��a *�k+ %a %�%a %Y hO�a &W X  *a ����a + � �������9:��
�� .Mth:NuHenull���     long�� 0 	thenumber 	theNumber�� ��;<
�� 
Plac; {�������� 0 padsize padSize��  ��  < ��=��
�� 
Pref= {�������� 0 	hasprefix 	hasPrefix��  
�� boovtrue��  9 	�������������������� 0 	thenumber 	theNumber�� 0 padsize padSize�� 0 	hasprefix 	hasPrefix�� 0 hextext hexText�� 0 	hexprefix 	hexPrefix�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo: ��(4��:HPZp���������>������� (0 asintegerparameter asIntegerParameter�� (0 asbooleanparameter asBooleanParameter
�� 
cobj�� 
�� 
leng�� 0 etext eText> ����?
�� 
errn�� 0 enumber eNumber? ����@
�� 
erob�� 0 efrom eFrom@ ������
�� 
errt�� 
0 eto eTo��  �� �� 
0 _error  �� � �b  ��l+ E�Ob  ��l+ E�Ob  ��l+ E�O�E�O�j �E�O�'E�Y �E�O� 
��%E�Y hO h�j���#k/�%E�O��"E�[OY��O h��,���%E�[OY��O��%W X  *a ����a + � �������AB��
�� .Mth:HeNunull���     ctxt�� 0 hextext hexText�� ��C��
�� 
PrecC {�������� 0 	isprecise 	isPrecise��  
�� boovtrue��  A 
���������������������� 0 hextext hexText�� 0 	isprecise 	isPrecise�� 0 	thenumber 	theNumber�� 0 
isnegative 
isNegative�� 0 charref charRef�� 0 i  �� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eToB #��������������������������	����������������������,��DJ������ "0 astextparameter asTextParameter�� (0 asbooleanparameter asBooleanParameter
�� 
ctxt
�� 
kocl
�� 
cobj
�� .corecnte****       ****�� 
�� misccura
�� 
psof
�� 
psin�� 
�� .sysooffslong    ��� null��  ��  
�� 
errn���Y
�� 
erob
�� 
bool
�� 
errt
�� 
doub�� �� 0 etext eTextD ����E
�� 
errn�� 0 enumber eNumberE ����F
�� 
erob�� 0 efrom eFromF ������
�� 
errt�� 
0 eto eTo��  �� �� 
0 _error  �� ��� �b  ��l+ E�Ob  ��l+ E�O �jE�O��E�O� �[�\[Zl\Zi2E�Y hO�� �[�\[Zm\Zi2E�Y hO E�[��l kh �� E�O� *��a a  UE�O�j  	)jhY hO��kE�[OY��W X  )a a a �a a O�	 ��k a & )a a a �a a a a Y hO� 	�'E�Y hO�VW X  *a  ����a !+ "� ��f����GH��
�� .Mth:DeRanull���     doub�� 0 n  ��  G ������������ 0 n  �� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eToH ��������I~����
�� 
doub
�� 
pi  �� ��� 0 etext eTextI ����J
�� 
errn�� 0 enumber eNumberJ ����K
�� 
erob�� 0 efrom eFromK ������
�� 
errt�� 
0 eto eTo��  �� �� 
0 _error  ��  ��&��! W X  *塢���+ � �������LM��
�� .Mth:RaDenull���     doub�� 0 n  ��  L ������������ 0 n  �� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eToM ������N���~
�� 
pi  �� ��� 0 etext eTextN �}�|O
�} 
errn�| 0 enumber eNumberO �{�zP
�{ 
erob�z 0 efrom eFromP �y�x�w
�y 
errt�x 
0 eto eTo�w  � �~ 
0 _error  ��  ���!!W X  *䡢���+ � �v��u�tQR�s
�v .Mth:Abs_null���     nmbr�u 0 n  �t  Q �r�q�p�o�n�r 0 n  �q 0 etext eText�p 0 enumber eNumber�o 0 efrom eFrom�n 
0 eto eToR �m�lS��k�j
�m 
nmbr�l 0 etext eTextS �i�hT
�i 
errn�h 0 enumber eNumberT �g�fU
�g 
erob�f 0 efrom eFromU �e�d�c
�e 
errt�d 
0 eto eTo�c  �k �j 
0 _error  �s * ��&E�O�j �'Y �W X  *㡢���+ � �b��a�`VW�_
�b .Mth:CmpNnull���     ****�a �^X�^ X  �]�\�] 0 n1  �\ 0 n2  �`  V �[�Z�Y�X�W�V�[ 0 n1  �Z 0 n2  �Y 0 etext eText�X 0 enumber eNumber�W 0 efrom eFrom�V 
0 eto eToW �U�T�S�RY!�Q�P
�U 
doub
�T 
cobj
�S 
bool�R 0 etext eTextY �O�NZ
�O 
errn�N 0 enumber eNumberZ �M�L[
�M 
erob�L 0 efrom eFrom[ �K�J�I
�K 
errt�J 
0 eto eTo�I  �Q �P 
0 _error  �_ Z I��&��&lvE[�k/E�Z[�l/E�ZO�b  �	 �b  ��& jY �� iY kW X  *墣���+ � �H1�G�F\]�E
�H .Mth:MinNnull���     ****�G 0 thelist theList�F  \ �D�C�B�A�@�?�>�=�D 0 thelist theList�C 0 	theresult 	theResult�B 0 aref aRef�A 0 n  �@ 0 etext eText�? 0 enumber eNumber�> 0 efrom eFrom�= 
0 eto eTo] A�<�;�:�9�8�7�6^m�5�4�< "0 aslistparameter asListParameter
�; 
cobj
�: 
nmbr
�9 
kocl
�8 .corecnte****       ****
�7 
pcnt�6 0 etext eText^ �3�2_
�3 
errn�2 0 enumber eNumber_ �1�0`
�1 
erob�0 0 efrom eFrom` �/�.�-
�/ 
errt�. 
0 eto eTo�-  �5 �4 
0 _error  �E Z Ib  ��l+ E�O��k/�&E�O )�[��l kh ��,�&E�O�� �E�Y h[OY��O�W X  *餥���+ � �,}�+�*ab�)
�, .Mth:MaxNnull���     ****�+ 0 thelist theList�*  a �(�'�&�%�$�#�"�!�( 0 thelist theList�' 0 	theresult 	theResult�& 0 aref aRef�% 0 n  �$ 0 etext eText�# 0 enumber eNumber�" 0 efrom eFrom�! 
0 eto eTob �� ������c����  "0 aslistparameter asListParameter
� 
cobj
� 
nmbr
� 
kocl
� .corecnte****       ****
� 
pcnt� 0 etext eTextc ��d
� 
errn� 0 enumber eNumberd ��e
� 
erob� 0 efrom eFrome ���
� 
errt� 
0 eto eTo�  � � 
0 _error  �) Z Ib  ��l+ E�O��k/�&E�O )�[��l kh ��,�&E�O�� �E�Y h[OY��O�W X  *餥���+   ����fg�
� .Mth:RouNnull���     doub� 0 num  � �hi
� 
Plach {��
�	� 0 decimalplaces decimalPlaces�
  �	  i �j�
� 
Direj {���� &0 roundingdirection roundingDirection�  
� MRndRNhE�  f ���� ��������� 0 num  � 0 decimalplaces decimalPlaces� &0 roundingdirection roundingDirection�  0 themultiplier theMultiplier�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTog ����������)+J��h�������������������k������ "0 asrealparameter asRealParameter�� (0 asintegerparameter asIntegerParameter�� 

�� MRndRNhE
�� MRndRNhT
�� MRndRNhF
�� MRndRN_T
�� MRndRN_F
�� MRndRN_U
�� 
bool
�� MRndRN_D�� >0 throwinvalidparameterconstant throwInvalidParameterConstant�� 0 etext eTextk ����l
�� 
errn�� 0 enumber eNumberl ����m
�� 
erob�� 0 efrom eFromm ������
�� 
errt�� 
0 eto eTo��  �� �� 
0 _error  �hSb  ��l+ E�Ob  ��l+ E�O�j �$E�O�� � �!E�Y hO��  3��lv�l!k#kv 
�k"E�Y �j ��k"E�Y 	��k"E�Y Ģ�  1��lv�k#kv 
�k"E�Y �j ��k"E�Y 	��k"E�Y ���  	)j�Y ���  
�k"E�Y t��  	)j�Y g�a   &�j
 �k#j a & 
�k"E�Y 	�kk"E�Y ;�a   &�j
 �k#j a & 
�k"E�Y 	�kk"E�Y b  �a l+ O�j  	�k"Y �j 	��"Y ��!W X  *a ����a +  ��3����no���� 0 _sin  �� ��p�� p  ���� 0 x  ��  n �������������� 0 x  �� 0 isneg isNeg�� 0 y  �� 0 z  �� 0 z2  �� 0 zz  o �����������������������							
	,	-	.	/	0	1�� 
�� 
cobj��h
�� 
pi  �� ��� �� �� 
�� 
bool����#j  $�j 	�'E�Y hOb  ��#�"k/EY hO��#� �!E�O�jE�O� 	�'E�Y hO���! k"E�O��� k"� E�O�l#k  �kE�O�kE�Y hO��#E�O�m �E�O��E�Y hO��� �� �� E�O�� E�O�k 
 �l �& .��l!�� � �� a � a � a � a  E�Y +��� a � a � a � a � a � a  E�O� 	�'E�Y hO� ��	D����qr��
�� .Mth:Sin_null���     doub�� 0 n  ��  q �������������� 0 n  �� 0 x  �� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTor ������s	X����
�� 
nmbr�� 0 _sin  �� 0 etext eTexts ����t
�� 
errn�� 0 enumber eNumbert ����u
�� 
erob�� 0 efrom eFromu ������
�� 
errt�� 
0 eto eTo��  �� �� 
0 _error  ��  *��&k+ W X  *䢣���+  ��	h����vw��
�� .Mth:Cos_null���     doub�� 0 n  ��  v ������������ 0 n  �� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTow ��������x	����
�� 
nmbr�� Z�� 0 _sin  �� 0 etext eTextx ����y
�� 
errn�� 0 enumber eNumbery ����z
�� 
erob�� 0 efrom eFromz ������
�� 
errt�� 
0 eto eTo��  �� �� 
0 _error  �� ! *��&�k+ W X  *塢���+  ��	�����{|��
�� .Mth:Tan_null���     doub�� 0 n  ��  { ������������������������ 0 n  �� 0 x  �� 0 isneg isNeg�� 0 y  �� 0 z  �� 0 z2  �� 0 zz  �� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo| !���������������	�����
�
%
(
+
9
N
O
P
c
d
e
f��}
���
�� 
nmbr�� �� Z��
�� 
bool
�� 
errn��Y
� 
erob� 
� 
cobj�h
� 
pi  � �� � � 0 etext eText} ��~
� 
errn� 0 enumber eNumber~ ��
� 
erob� 0 efrom eFrom ��~�}
� 
errt�~ 
0 eto eTo�}  � � 
0 _error  ��5 ��&E�O��#j  ?�j 	�'E�Y hO�� 
 �� �& )�����Y hOb  ��#�"k/EY hO��#� �!E�O�jE�O� 	�'E�Y hO���!!k"E�O��� k"� E�O�l#k  �kE�O�kE�Y hO��a  �a  �a  E�O�� E�O�a  4��� a � a � a  �a � a � a � a !E�Y �E�O�l 
 	�a  �& 
i�!E�Y hO� 	�'E�Y hO�W X  *a ����a +   �|
��{�z���y�| 	0 _asin  �{ �x��x �  �w�w 0 n  �z  � �v�u�t�s�r�q�v 0 n  �u 0 x  �t 0 isneg isNeg�s 0 zz  �r 0 p  �q 0 z  � �p�o�n�m
�
�
�
�
�
�
�	
�l&5defghi������k
�p 
errn�o�Y
�n 
erob�m 
�l 
pi  �k ��y ��jE�O� 	�'E�Y hO�k )�����Y hO�� Xk�E�O�� �� �� �� � ��� �� �� �!E�O���$E�O_ �!�E�O�� a E�O��_ �!E�Y ]�a  �E�Y O�� E�O�a � a � a � a � a � a  �a � a � a � a � a !� �E�O� 	�'E�Y hO�_ a !! �j��i�h���g
�j .Mth:Sinanull���     doub�i 0 n  �h  � �f�e�d�c�b�f 0 n  �e 0 etext eText�d 0 enumber eNumber�c 0 efrom eFrom�b 
0 eto eTo� �a�`�_���^�]
�a 
nmbr�` 	0 _asin  �_ 0 etext eText� �\�[�
�\ 
errn�[ 0 enumber eNumber� �Z�Y�
�Z 
erob�Y 0 efrom eFrom� �X�W�V
�X 
errt�W 
0 eto eTo�V  �^ �] 
0 _error  �g  *��&k+ W X  *䡢���+  �U��T�S���R
�U .Mth:Cosanull���     doub�T 0 n  �S  � �Q�P�O�N�M�Q 0 n  �P 0 etext eText�O 0 enumber eNumber�N 0 efrom eFrom�M 
0 eto eTo� �L�K�J�I���H�G�L Z
�K 
nmbr�J 	0 _asin  �I 0 etext eText� �F�E�
�F 
errn�E 0 enumber eNumber� �D�C�
�D 
erob�C 0 efrom eFrom� �B�A�@
�B 
errt�A 
0 eto eTo�@  �H �G 
0 _error  �R ! �*��&k+ W X  *塢���+  �?��>�=���<
�? .Mth:Tananull���     doub�> 0 n  �=  � �;�:�9�8�7�6�; 0 n  �: 0 x  �9 0 etext eText�8 0 enumber eNumber�7 0 efrom eFrom�6 
0 eto eTo� �5�4�3��2�1
�5 
nmbr�4 	0 _asin  �3 0 etext eText� �0�/�
�0 
errn�/ 0 enumber eNumber� �.�-�
�. 
erob�- 0 efrom eFrom� �,�+�*
�, 
errt�+ 
0 eto eTo�*  �2 �1 
0 _error  �< + ��&E�O*��� k�$!k+ W X  *墣���+ 	 �))�(�'���&
�) .Mth:Sinhnull���     doub�( 0 n  �'  � �%�$�#�"�!� �% 0 n  �$ 0 x  �# 0 etext eText�" 0 enumber eNumber�! 0 efrom eFrom�  
0 eto eTo� �9��L��
� 
nmbr� 0 etext eText� ���
� 
errn� 0 enumber eNumber� ���
� 
erob� 0 efrom eFrom� ���
� 
errt� 
0 eto eTo�  � � 
0 _error  �& / ��&E�O�b  �$b  �'$ W X  *䢣���+ 
 �\�����
� .Mth:Coshnull���     doub� 0 n  �  � ������� 0 n  � 0 x  � 0 etext eText� 0 enumber eNumber� 0 efrom eFrom� 
0 eto eTo� �
l�	���
�
 
nmbr�	 0 etext eText� ���
� 
errn� 0 enumber eNumber� ���
� 
erob� 0 efrom eFrom� ��� 
� 
errt� 
0 eto eTo�   � � 
0 _error  � / ��&E�O�b  �$b  �'$ W X  *䢣���+  �����������
�� .Mth:Tanhnull���     doub�� 0 n  ��  � �������������� 0 n  �� 0 x  �� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo� ����������
�� 
nmbr�� 0 etext eText� �����
�� 
errn�� 0 enumber eNumber� �����
�� 
erob�� 0 efrom eFrom� ������
�� 
errt�� 
0 eto eTo��  �� �� 
0 _error  �� > -��&E�Ob  �$b  �'$b  �$b  �'$!W X  *㢣���+  ������������� 
0 _frexp  �� ����� �  ���� 0 m  ��  � �������� 0 m  �� 0 isneg isNeg�� 0 e  � ���
�� 
bool�� o�j  
�jlvY hO�jE�O� 	�'E�Y hOjE�O 3h��	 �k�&�k �l!E�O�kE�Y �l E�O�kE�[OY��O� 	�'E�Y hO��lv ��2���������� 	0 _logn  �� ����� �  ���� 0 x  ��  � ���������� 0 x  �� 0 e  �� 0 z  �� 0 y  � ����>��������^o��������56789
�� 
errn���Y�� 
0 _frexp  
�� 
cobj����
�� 
bool��<�j )��l�Y hO*�k+ E[�k/E�Z[�l/E�ZO��
 �l�& j�� �kE�O��E�O� �E�Y �kE�O� �E�O��!E�O�� E�O�� � �� � ��� �� �!E�O�E�O��� ��a  E�Y ��� �kE�Ol� kE�Y �kE�O�� E�O�� a � a � a � a � a � a  �a � a � a � a � a !E�O�j ��� E�Y hO��l!E�O��E�O�j ��a  E�Y hO� ��m��������
�� .Mth:Lognnull���     doub�� 0 n  ��  � ������������ 0 n  �� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo� ������������
�� 
nmbr�� 	0 _logn  �� 0 etext eText� �����
�� 
errn�� 0 enumber eNumber� ����
�� 
erob� 0 efrom eFrom� ���
� 
errt� 
0 eto eTo�  �� �� 
0 _error  ��  *��&k+ W X  *䡢���+  �������
� .Mth:Lo10null���     doub� 0 n  �  � ������ 0 n  � 0 etext eText� 0 enumber eNumber� 0 efrom eFrom� 
0 eto eTo� 
����������
� 
nmbr� 	0 _logn  � 0 etext eText� ���
� 
errn� 0 enumber eNumber� ���
� 
erob� 0 efrom eFrom� ���
� 
errt� 
0 eto eTo�  � � 
0 _error  � % *��&k+ �!� �!W X  *硢���+ 	 �������
� .Mth:Logbnull���     doub� 0 n  � ���
� 
Base� 0 b  �  � ������� 0 n  � 0 b  � 0 etext eText� 0 enumber eNumber� 0 efrom eFrom� 
0 eto eTo� �������
� 
nmbr� 	0 _logn  � 0 etext eText� ���
� 
errn� 0 enumber eNumber� ���
� 
erob� 0 efrom eFrom� ���
� 
errt� 
0 eto eTo�  � � 
0 _error  � ( *��&k+ *��&k+ !W X  *䢣���+  ascr  ��ޭ