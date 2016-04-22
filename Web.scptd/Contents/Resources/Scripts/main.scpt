FasdUAS 1.101.10   ��   ��    k             l      ��  ��   	 Web -- commands for manipulating URLs and sending HTTP requests

TO DO:

- add `normalize URL` handler? see NSURL's standardizedURL(); need to decide if it's worth putting in for users to call directly (note that `split URL` and anything else that uses TypeSupport's asNSURLParameter() already normalizes URLs automatically; OTOH, `join URL` does not)


- what about `split/join URL parameter string`? (see also below)

- how to split path components from parameter strings? RFC2396 allows parameters on all path portions (NSURL only allows parameters after final path portion), so probably also need to rework/rewrite `split/join URL` handlers to support this newer form as standard; see also Python's urllib.parse.urlsplit(), which unlike its older NSURL-like urlparse() function doesn't split parameters from path (although Python doesn't provide a parse function for such paths either, presumably leaving it to users to deal with themselves as needed).

   3.3. Path Component

   The path component contains data, specific to the authority (or the
   scheme if there is no authority component), identifying the resource
   within the scope of that scheme and authority.

      --path          = [ abs_path | opaque_part ]

      --path_segments = segment *( "/" segment )
      --segment       = *pchar *( ";" param )
      --param         = *pchar

      --pchar         = unreserved | escaped | ":" | "@" | "&" | "=" | "+" | "$" | ","

   The path may consist of a sequence of path segments separated by a
   single slash "/" character.  Within a path segment, the characters
   "/", ";", "=", and "?" are reserved.  Each path segment may include a
   sequence of parameters, indicated by the semicolon ";" character.
   The parameters are not significant to the parsing of relative
   references.


- NSURL's component properties don't appear to support generic resource locators, e.g. given "mailto:foo@example.org", NSURL.path returns nil; may be the case that a vanilla parser implemented according to RFC3986 would be a better solution than using NSURL



- commands for converting HTML entities? (&amp;/&lt;/&gt;/&quot;); what about &apos;? what about non-ASCII entities? (decode command would need to handle all entities; encode command could probably just do required entities which is sufficient for use in Unicode [UTF8] encoded documents, possibly providing a Boolean option to encode all non-ASCII entities should users have to produce non-Unicode documents [though this shouldn't be encouraged]); OTOH, one might argue that if users are dealing with HTML content they should use a proper library that understands and processes HTML correctly, and providing commands here for encoding/decoding HTML entities is just encouraging them to hack it (something a stdlib really shouldn't do); given what a mess of complexity it is, might be wisest to leave HTML processing for other libraries to deal with

	- see NSString's stringByApplyingTransform:reverse:, using "Any-Hex/XML;Any-Hex/XML10" to convert "&#x10FFFF;" and "&1114111;" (what about HTML entity names?)

     � 	 	   W e b   - -   c o m m a n d s   f o r   m a n i p u l a t i n g   U R L s   a n d   s e n d i n g   H T T P   r e q u e s t s 
 
 T O   D O : 
 
 -   a d d   ` n o r m a l i z e   U R L `   h a n d l e r ?   s e e   N S U R L ' s   s t a n d a r d i z e d U R L ( ) ;   n e e d   t o   d e c i d e   i f   i t ' s   w o r t h   p u t t i n g   i n   f o r   u s e r s   t o   c a l l   d i r e c t l y   ( n o t e   t h a t   ` s p l i t   U R L `   a n d   a n y t h i n g   e l s e   t h a t   u s e s   T y p e S u p p o r t ' s   a s N S U R L P a r a m e t e r ( )   a l r e a d y   n o r m a l i z e s   U R L s   a u t o m a t i c a l l y ;   O T O H ,   ` j o i n   U R L `   d o e s   n o t ) 
 
 
 -   w h a t   a b o u t   ` s p l i t / j o i n   U R L   p a r a m e t e r   s t r i n g ` ?   ( s e e   a l s o   b e l o w ) 
 
 -   h o w   t o   s p l i t   p a t h   c o m p o n e n t s   f r o m   p a r a m e t e r   s t r i n g s ?   R F C 2 3 9 6   a l l o w s   p a r a m e t e r s   o n   a l l   p a t h   p o r t i o n s   ( N S U R L   o n l y   a l l o w s   p a r a m e t e r s   a f t e r   f i n a l   p a t h   p o r t i o n ) ,   s o   p r o b a b l y   a l s o   n e e d   t o   r e w o r k / r e w r i t e   ` s p l i t / j o i n   U R L `   h a n d l e r s   t o   s u p p o r t   t h i s   n e w e r   f o r m   a s   s t a n d a r d ;   s e e   a l s o   P y t h o n ' s   u r l l i b . p a r s e . u r l s p l i t ( ) ,   w h i c h   u n l i k e   i t s   o l d e r   N S U R L - l i k e   u r l p a r s e ( )   f u n c t i o n   d o e s n ' t   s p l i t   p a r a m e t e r s   f r o m   p a t h   ( a l t h o u g h   P y t h o n   d o e s n ' t   p r o v i d e   a   p a r s e   f u n c t i o n   f o r   s u c h   p a t h s   e i t h e r ,   p r e s u m a b l y   l e a v i n g   i t   t o   u s e r s   t o   d e a l   w i t h   t h e m s e l v e s   a s   n e e d e d ) . 
 
       3 . 3 .   P a t h   C o m p o n e n t 
 
       T h e   p a t h   c o m p o n e n t   c o n t a i n s   d a t a ,   s p e c i f i c   t o   t h e   a u t h o r i t y   ( o r   t h e 
       s c h e m e   i f   t h e r e   i s   n o   a u t h o r i t y   c o m p o n e n t ) ,   i d e n t i f y i n g   t h e   r e s o u r c e 
       w i t h i n   t h e   s c o p e   o f   t h a t   s c h e m e   a n d   a u t h o r i t y . 
 
             - - p a t h                     =   [   a b s _ p a t h   |   o p a q u e _ p a r t   ] 
 
             - - p a t h _ s e g m e n t s   =   s e g m e n t   * (   " / "   s e g m e n t   ) 
             - - s e g m e n t               =   * p c h a r   * (   " ; "   p a r a m   ) 
             - - p a r a m                   =   * p c h a r 
 
             - - p c h a r                   =   u n r e s e r v e d   |   e s c a p e d   |   " : "   |   " @ "   |   " & "   |   " = "   |   " + "   |   " $ "   |   " , " 
 
       T h e   p a t h   m a y   c o n s i s t   o f   a   s e q u e n c e   o f   p a t h   s e g m e n t s   s e p a r a t e d   b y   a 
       s i n g l e   s l a s h   " / "   c h a r a c t e r .     W i t h i n   a   p a t h   s e g m e n t ,   t h e   c h a r a c t e r s 
       " / " ,   " ; " ,   " = " ,   a n d   " ? "   a r e   r e s e r v e d .     E a c h   p a t h   s e g m e n t   m a y   i n c l u d e   a 
       s e q u e n c e   o f   p a r a m e t e r s ,   i n d i c a t e d   b y   t h e   s e m i c o l o n   " ; "   c h a r a c t e r . 
       T h e   p a r a m e t e r s   a r e   n o t   s i g n i f i c a n t   t o   t h e   p a r s i n g   o f   r e l a t i v e 
       r e f e r e n c e s . 
 
 
 -   N S U R L ' s   c o m p o n e n t   p r o p e r t i e s   d o n ' t   a p p e a r   t o   s u p p o r t   g e n e r i c   r e s o u r c e   l o c a t o r s ,   e . g .   g i v e n   " m a i l t o : f o o @ e x a m p l e . o r g " ,   N S U R L . p a t h   r e t u r n s   n i l ;   m a y   b e   t h e   c a s e   t h a t   a   v a n i l l a   p a r s e r   i m p l e m e n t e d   a c c o r d i n g   t o   R F C 3 9 8 6   w o u l d   b e   a   b e t t e r   s o l u t i o n   t h a n   u s i n g   N S U R L 
 
 
 
 -   c o m m a n d s   f o r   c o n v e r t i n g   H T M L   e n t i t i e s ?   ( & a m p ; / & l t ; / & g t ; / & q u o t ; ) ;   w h a t   a b o u t   & a p o s ; ?   w h a t   a b o u t   n o n - A S C I I   e n t i t i e s ?   ( d e c o d e   c o m m a n d   w o u l d   n e e d   t o   h a n d l e   a l l   e n t i t i e s ;   e n c o d e   c o m m a n d   c o u l d   p r o b a b l y   j u s t   d o   r e q u i r e d   e n t i t i e s   w h i c h   i s   s u f f i c i e n t   f o r   u s e   i n   U n i c o d e   [ U T F 8 ]   e n c o d e d   d o c u m e n t s ,   p o s s i b l y   p r o v i d i n g   a   B o o l e a n   o p t i o n   t o   e n c o d e   a l l   n o n - A S C I I   e n t i t i e s   s h o u l d   u s e r s   h a v e   t o   p r o d u c e   n o n - U n i c o d e   d o c u m e n t s   [ t h o u g h   t h i s   s h o u l d n ' t   b e   e n c o u r a g e d ] ) ;   O T O H ,   o n e   m i g h t   a r g u e   t h a t   i f   u s e r s   a r e   d e a l i n g   w i t h   H T M L   c o n t e n t   t h e y   s h o u l d   u s e   a   p r o p e r   l i b r a r y   t h a t   u n d e r s t a n d s   a n d   p r o c e s s e s   H T M L   c o r r e c t l y ,   a n d   p r o v i d i n g   c o m m a n d s   h e r e   f o r   e n c o d i n g / d e c o d i n g   H T M L   e n t i t i e s   i s   j u s t   e n c o u r a g i n g   t h e m   t o   h a c k   i t   ( s o m e t h i n g   a   s t d l i b   r e a l l y   s h o u l d n ' t   d o ) ;   g i v e n   w h a t   a   m e s s   o f   c o m p l e x i t y   i t   i s ,   m i g h t   b e   w i s e s t   t o   l e a v e   H T M L   p r o c e s s i n g   f o r   o t h e r   l i b r a r i e s   t o   d e a l   w i t h 
 
 	 -   s e e   N S S t r i n g ' s   s t r i n g B y A p p l y i n g T r a n s f o r m : r e v e r s e : ,   u s i n g   " A n y - H e x / X M L ; A n y - H e x / X M L 1 0 "   t o   c o n v e r t   " & # x 1 0 F F F F ; "   a n d   " & 1 1 1 4 1 1 1 ; "   ( w h a t   a b o u t   H T M L   e n t i t y   n a m e s ? ) 
 
   
  
 l     ��������  ��  ��        x     �� ����    4    �� 
�� 
frmk  m       �    F o u n d a t i o n��        l     ��������  ��  ��        l     ��������  ��  ��        l     ��  ��    J D--------------------------------------------------------------------     �   � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -      l     ��  ��      support     �      s u p p o r t     !   l     ��������  ��  ��   !  " # " l      $ % & $ j    �� '�� 0 _support   ' N     ( ( 4    �� )
�� 
scpt ) m     * * � + +  T y p e S u p p o r t % "  used for parameter checking    & � , , 8   u s e d   f o r   p a r a m e t e r   c h e c k i n g #  - . - l     ��������  ��  ��   .  / 0 / l     ��������  ��  ��   0  1 2 1 i    3 4 3 I      �� 5���� 
0 _error   5  6 7 6 o      ���� 0 handlername handlerName 7  8 9 8 o      ���� 0 etext eText 9  : ; : o      ���� 0 enumber eNumber ;  < = < o      ���� 0 efrom eFrom =  >�� > o      ���� 
0 eto eTo��  ��   4 n     ? @ ? I    �� A���� &0 throwcommanderror throwCommandError A  B C B m     D D � E E  W e b C  F G F o    ���� 0 handlername handlerName G  H I H o    ���� 0 etext eText I  J K J o    	���� 0 enumber eNumber K  L M L o   	 
���� 0 efrom eFrom M  N�� N o   
 ���� 
0 eto eTo��  ��   @ o     ���� 0 _support   2  O P O l     ��������  ��  ��   P  Q R Q l     ��������  ��  ��   R  S T S l     �� U V��   U J D--------------------------------------------------------------------    V � W W � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - T  X Y X l     �� Z [��   Z   URL conversion    [ � \ \    U R L   c o n v e r s i o n Y  ] ^ ] l     ��������  ��  ��   ^  _ ` _ l     �� a b��   a copied from Python's urllib.parse module (hardcoded blacklists/whitelists are always problematic as they need to be manually maintained and updated as new protocols arise, but this one seems unavoidable); used to determine when `join URL` should insert "//"    b � c c   c o p i e d   f r o m   P y t h o n ' s   u r l l i b . p a r s e   m o d u l e   ( h a r d c o d e d   b l a c k l i s t s / w h i t e l i s t s   a r e   a l w a y s   p r o b l e m a t i c   a s   t h e y   n e e d   t o   b e   m a n u a l l y   m a i n t a i n e d   a n d   u p d a t e d   a s   n e w   p r o t o c o l s   a r i s e ,   b u t   t h i s   o n e   s e e m s   u n a v o i d a b l e ) ;   u s e d   t o   d e t e r m i n e   w h e n   ` j o i n   U R L `   s h o u l d   i n s e r t   " / / " `  d e d j    N�� f�� 0 _usesnetloc _usesNetLoc f J    M g g  h i h m     j j � k k  f t p i  l m l m     n n � o o  h t t p m  p q p m     r r � s s  g o p h e r q  t u t m     v v � w w  n n t p u  x y x m     z z � { {  t e l n e t y  | } | m     ~ ~ �    i m a p }  � � � m     � � � � �  w a i s �  � � � m     � � � � �  f i l e �  � � � m     � � � � �  m m s �  � � � m    " � � � � � 
 h t t p s �  � � � m   " % � � � � � 
 s h t t p �  � � � m   % ( � � � � � 
 s n e w s �  � � � m   ( + � � � � �  p r o s p e r o �  � � � m   + . � � � � �  r t s p �  � � � m   . 1 � � � � � 
 r t s p u �  � � � m   1 4 � � � � � 
 r s y n c �  � � � m   4 7 � � � � �   �  � � � m   7 : � � � � �  s v n �  � � � m   : = � � � � �  s v n + s s h �  � � � m   = @ � � � � �  s f t p �  � � � m   @ C � � � � �  n f s �  � � � m   C F � � � � �  g i t �  ��� � m   F I � � � � �  g i t + s s h��   e  � � � l     ��������  ��  ��   �  � � � l     ��������  ��  ��   �  � � � i  O R � � � I      �� ����� 0 _ascomponent _asComponent �  ��� � o      ���� 0 
asocstring 
asocString��  ��   � k      � �  � � � Z     � ����� � =     � � � o     ���� 0 
asocstring 
asocString � m    ��
�� 
msng � L     � � m     � � � � �  ��  ��   �  ��� � L     � � c     � � � o    ���� 0 
asocstring 
asocString � m    ��
�� 
ctxt��   �  � � � l     ��������  ��  ��   �  � � � l     ��������  ��  ��   �  � � � i  S V � � � I      �� ����� ,0 _joinnetworklocation _joinNetworkLocation �  ��� � o      ���� .0 networklocationrecord networkLocationRecord��  ��   � k    $ � �  � � � r      � � � n     � � � I    �� ����� 60 asoptionalrecordparameter asOptionalRecordParameter �  � � � o    ���� .0 networklocationrecord networkLocationRecord �  � � � K     � � �� � ��� 0 username userName � m     � � � � �   � �� � ��� 0 userpassword userPassword � m   	 
 � � � � �   � �� � ��� 0 hostname hostName � m     � � � � �   � �� ����� 0 
portnumber 
portNumber � m     � � �    ��   � �� m     �  ��  ��   � o     ���� 0 _support   � o      ���� $0 fullnetlocrecord fullNetLocRecord �  r    . n    ,	 J    ,

  o    ���� 0 username userName  o     ���� 0 userpassword userPassword  o   " $���� 0 hostname hostName �� o   & (���� 0 
portnumber 
portNumber��  	 o    ���� $0 fullnetlocrecord fullNetLocRecord o      ���� 0 urlcomponents urlComponents  X   / ��� Q   ? � r   B M c   B I n  B E 1   C E��
�� 
pcnt o   B C���� 0 aref aRef m   E H��
�� 
ctxt n       1   J L��
�� 
pcnt  o   I J���� 0 aref aRef R      ����!
�� .ascrerr ****      � ****��  ! ��"��
�� 
errn" d      ## m      �������   R   U ���$%
�� .ascrerr ****      � ****$ b   a �&'& b   a |()( m   a d** �++ D I n v a l i d   n e t w o r k   l o c a t i o n   r e c o r d   ( ) l  d {,����, n   d {-.- 4   r {��/
�� 
cobj/ l  s z0����0 [   s z121 l  s x3����3 n   s x454 1   t x��
�� 
leng5 o   s t���� 0 urlcomponents urlComponents��  ��  2 m   x y���� ��  ��  . J   d r66 787 m   d g99 �::  u s e r N a m e8 ;<; m   g j== �>>  u s e r P a s s w o r d< ?@? m   j mAA �BB  h o s t N a m e@ C��C m   m pDD �EE  p o r t N u m b e r��  ��  ��  ' m   | FF �GG 0    p r o p e r t y   i s   n o t   t e x t ) .% ��HI
�� 
errnH m   Y \�����YI �J�~
� 
erobJ o   _ `�}�} 0 	urlrecord 	urlRecord�~  �� 0 aref aRef o   2 3�|�| 0 urlcomponents urlComponents KLK r   � �MNM o   � ��{�{ 0 urlcomponents urlComponentsN J      OO PQP o      �z�z 0 username userNameQ RSR o      �y�y 0 userpassword userPasswordS TUT o      �x�x 0 hostname hostNameU V�wV o      �v�v 0 
portnumber 
portNumber�w  L WXW l  � ��uYZ�u  Y F @ TO DO: if userName is "" and userPassword is not "" then error?   Z �[[ �   T O   D O :   i f   u s e r N a m e   i s   " "   a n d   u s e r P a s s w o r d   i s   n o t   " "   t h e n   e r r o r ?X \]\ Z  � �^_�t�s^ >  � �`a` o   � ��r�r 0 userpassword userPassworda m   � �bb �cc  _ r   � �ded b   � �fgf b   � �hih o   � ��q�q 0 username userNamei m   � �jj �kk  :g o   � ��p�p 0 userpassword userPassworde o      �o�o 0 username userName�t  �s  ] lml Z  � �no�n�mn >  � �pqp o   � ��l�l 0 username userNameq m   � �rr �ss  o r   � �tut b   � �vwv o   � ��k�k 0 username userNamew m   � �xx �yy  @u o      �j�j 0 username userName�n  �m  m z{z Z  �|}�i�h| F   � �~~ =  � ���� o   � ��g�g 0 hostname hostName� m   � ��� ���   H   � ��� l  � ���f�e� F   � ���� =  � ���� o   � ��d�d 0 username userName� m   � ��� ���  � =  � ���� o   � ��c�c 0 
portnumber 
portNumber� m   � ��� ���  �f  �e  } R   ��b��
�b .ascrerr ****      � ****� m   � �� ��� | I n v a l i d   n e t w o r k   l o c a t i o n   r e c o r d   ( m i s s i n g    h o s t N a m e    p r o p e r t y ) .� �a��
�a 
errn� m   � ��`�`�Y� �_��^
�_ 
erob� o   � ��]�] 0 	urlrecord 	urlRecord�^  �i  �h  { ��� r  ��� b  	��� o  �\�\ 0 username userName� o  �[�[ 0 hostname hostName� o      �Z�Z 0 hostname hostName� ��� Z !���Y�X� > ��� o  �W�W 0 
portnumber 
portNumber� m  �� ���  � r  ��� b  ��� b  ��� o  �V�V 0 hostname hostName� m  �� ���  :� o  �U�U 0 
portnumber 
portNumber� o      �T�T 0 hostname hostName�Y  �X  � ��S� L  "$�� o  "#�R�R 0 hostname hostName�S   � ��� l     �Q�P�O�Q  �P  �O  � ��� l     �N�M�L�N  �M  �L  � ��� l     �K���K  �  -----   � ��� 
 - - - - -� ��� l     �J�I�H�J  �I  �H  � ��� i  W Z��� I     �G��
�G .Web:SplUnull���     ctxt� o      �F�F 0 urltext urlText� �E��D
�E 
NeLo� |�C�B��A��C  �B  � o      �@�@ ,0 splitnetworklocation splitNetworkLocation�A  � l     ��?�>� m      �=
�= boovfals�?  �>  �D  � Q     ����� k    ��� ��� r    ��� n   ��� I    �<��;�< $0 asnsurlparameter asNSURLParameter� ��� o    	�:�: 0 urltext urlText� ��9� m   	 
�� ���  �9  �;  � o    �8�8 0 _support  � o      �7�7 0 asocurl asocURL� ��� l   �6���6  �+% TO DO: NSURL doesn't seem to support newer RFC2396 which allows parameters on all path components, so probably have to rework this to re-join resourcePath with parameterString (eliminating parameterString property), or else replace with vanilla URL parser (which might be simpler in practice)   � ���J   T O   D O :   N S U R L   d o e s n ' t   s e e m   t o   s u p p o r t   n e w e r   R F C 2 3 9 6   w h i c h   a l l o w s   p a r a m e t e r s   o n   a l l   p a t h   c o m p o n e n t s ,   s o   p r o b a b l y   h a v e   t o   r e w o r k   t h i s   t o   r e - j o i n   r e s o u r c e P a t h   w i t h   p a r a m e t e r S t r i n g   ( e l i m i n a t i n g   p a r a m e t e r S t r i n g   p r o p e r t y ) ,   o r   e l s e   r e p l a c e   w i t h   v a n i l l a   U R L   p a r s e r   ( w h i c h   m i g h t   b e   s i m p l e r   i n   p r a c t i c e )� ��� r    A��� K    ?�� �5���5 0 username userName� I    �4��3�4 0 _ascomponent _asComponent� ��2� n   ��� I    �1�0�/�1 0 user  �0  �/  � o    �.�. 0 asocurl asocURL�2  �3  � �-���- 0 userpassword userPassword� I    '�,��+�, 0 _ascomponent _asComponent� ��*� n   #��� I    #�)�(�'�) 0 password  �(  �'  � o    �&�& 0 asocurl asocURL�*  �+  � �%���% 0 hostname hostName� I   ( 2�$��#�$ 0 _ascomponent _asComponent� ��"� n  ) .��� I   * .�!� ��! 0 host  �   �  � o   ) *�� 0 asocurl asocURL�"  �#  � ���� 0 
portnumber 
portNumber� I   3 =���� 0 _ascomponent _asComponent� ��� n  4 9��� I   5 9���� 0 port  �  �  � o   4 5�� 0 asocurl asocURL�  �  �  � o      �� "0 networklocation networkLocation� ��� Z   B ]����� H   B N�� n  B M��� I   G M���� (0 asbooleanparameter asBooleanParameter� ��� o   G H�� ,0 splitnetworklocation splitNetworkLocation� ��� m   H I   � . n e t w o r k   l o c a t i o n   r e c o r d�  �  � o   B G�� 0 _support  � r   Q Y I   Q W��� ,0 _joinnetworklocation _joinNetworkLocation �
 o   R S�	�	 "0 networklocation networkLocation�
  �   o      �� "0 networklocation networkLocation�  �  � � L   ^ � K   ^ � �	
� 0 	urlscheme 	urlScheme	 I   _ i��� 0 _ascomponent _asComponent � n  ` e I   a e��� � 
0 scheme  �  �    o   ` a���� 0 asocurl asocURL�  �  
 ���� "0 networklocation networkLocation o   l m���� "0 networklocation networkLocation ���� 0 resourcepath resourcePath I   p z������ 0 _ascomponent _asComponent �� n  q v I   r v�������� 0 path  ��  ��   o   q r���� 0 asocurl asocURL��  ��   ���� "0 parameterstring parameterString I   } ������� 0 _ascomponent _asComponent �� n  ~ � I    ��������� "0 parameterstring parameterString��  ��   o   ~ ���� 0 asocurl asocURL��  ��   ���� 0 querystring queryString I   � ������� 0 _ascomponent _asComponent  ��  n  � �!"! I   � ��������� 	0 query  ��  ��  " o   � ����� 0 asocurl asocURL��  ��   ��#���� (0 fragmentidentifier fragmentIdentifier# I   � ���$���� 0 _ascomponent _asComponent$ %��% n  � �&'& I   � ��������� 0 fragment  ��  ��  ' o   � ����� 0 asocurl asocURL��  ��  ��  �  � R      ��()
�� .ascrerr ****      � ****( o      ���� 0 etext eText) ��*+
�� 
errn* o      ���� 0 enumber eNumber+ ��,-
�� 
erob, o      ���� 0 efrom eFrom- ��.��
�� 
errt. o      ���� 
0 eto eTo��  � I   � ���/���� 
0 _error  / 010 m   � �22 �33  s p l i t   U R L1 454 o   � ����� 0 etext eText5 676 o   � ����� 0 enumber eNumber7 898 o   � ����� 0 efrom eFrom9 :��: o   � ����� 
0 eto eTo��  ��  � ;<; l     ��������  ��  ��  < =>= l     ��������  ��  ��  > ?@? l     ��������  ��  ��  @ ABA i  [ ^CDC I     ��EF
�� .Web:JoiUnull���     WebCE o      ���� 0 	urlrecord 	urlRecordF ��G��
�� 
BaseG |����H��I��  ��  H o      ���� 0 baseurl baseURL��  I l     J����J m      KK �LL  ��  ��  ��  D l   |MNOM Q    |PQRP P   dSTUS k   cVV WXW Z   YZ��[Y >    \]\ l   ^����^ I   ��_`
�� .corecnte****       ****_ J    aa b��b o    	���� 0 	urlrecord 	urlRecord��  ` ��c��
�� 
koclc m    ��
�� 
reco��  ��  ��  ] m    ����  Z k   �dd efe l   ��gh��  g 0 * TO DO: see above TODO re. parameterString   h �ii T   T O   D O :   s e e   a b o v e   T O D O   r e .   p a r a m e t e r S t r i n gf jkj r    7lml n   5non I    5��p���� 60 asoptionalrecordparameter asOptionalRecordParameterp qrq o    ���� 0 	urlrecord 	urlRecordr sts K    .uu ��vw�� 0 	urlscheme 	urlSchemev m    xx �yy  w ��z{�� "0 networklocation networkLocationz m     || �}}  { ��~�� 0 resourcepath resourcePath~ m   ! "�� ���   ������ "0 parameterstring parameterString� m   # $�� ���  � ������ 0 querystring queryString� m   % &�� ���  � ������� (0 fragmentidentifier fragmentIdentifier� m   ' *�� ���  ��  t ���� m   . 1�� ���  ��  ��  o o    ���� 0 _support  m o      ���� 0 fullurlrecord fullURLRecordk ��� r   8 T��� n   8 R��� J   9 R�� ��� o   : <���� 0 	urlscheme 	urlScheme� ��� o   > @���� 0 resourcepath resourcePath� ��� o   B D���� "0 parameterstring parameterString� ��� o   F H���� 0 querystring queryString� ���� o   J L���� (0 fragmentidentifier fragmentIdentifier��  � o   8 9���� 0 fullurlrecord fullURLRecord� o      ���� 0 urlcomponents urlComponents� ��� X   U ������ Q   g ����� r   j y��� c   j s��� n  j o��� 1   k o��
�� 
pcnt� o   j k���� 0 aref aRef� m   o r��
�� 
ctxt� n     ��� 1   t x��
�� 
pcnt� o   s t���� 0 aref aRef� R      �����
�� .ascrerr ****      � ****��  � �����
�� 
errn� d      �� m      �������  � n  � ���� I   � �������� .0 throwinvalidparameter throwInvalidParameter� ��� o   � ����� 0 	urlrecord 	urlRecord� ��� m   � ��� ���  � ��� m   � ���
�� 
reco� ���� b   � ���� b   � ���� m   � ��� ��� 2 U R L   c o m p o n e n t s   r e c o r d  s   � l  � ������� n   � ���� 4   � ����
�� 
cobj� l  � ������� [   � ���� l  � ������� n   � ���� 1   � ���
�� 
leng� o   � ����� 0 urlcomponents urlComponents��  ��  � m   � ��� ��  ��  � J   � ��� ��� m   � ��� ���  u r l S c h e m e� ��� m   � ��� ���  r e s o u r c e P a t h� ��� m   � ��� ���  p a r a m e t e r S t r i n g� ��� m   � ��� ���  q u e r y S t r i n g� ��~� m   � ��� ��� $ f r a g m e n t I d e n t i f i e r�~  ��  ��  � m   � ��� ��� .    p r o p e r t y   i s   n o t   t e x t .��  ��  � o   � ��}�} 0 _support  �� 0 aref aRef� o   X Y�|�| 0 urlcomponents urlComponents� ��� r   � ���� o   � ��{�{ 0 urlcomponents urlComponents� J      �� ��� o      �z�z 0 	urlscheme 	urlScheme� ��� o      �y�y 0 resourcepath resourcePath� ��� o      �x�x "0 parameterstring parameterString� ��� o      �w�w 0 querystring queryString� ��v� o      �u�u (0 fragmentidentifier fragmentIdentifier�v  � ��� Z   �5���t�� >   � ���� l  � ���s�r� I  � ��q��
�q .corecnte****       ****� J   � ��� ��p� n  � ���� o   � ��o�o "0 networklocation networkLocation� o   � ��n�n 0 fullurlrecord fullURLRecord�p  � �m �l
�m 
kocl  m   � ��k
�k 
reco�l  �s  �r  � m   � ��j�j  � r   I  	�i�h�i ,0 _joinnetworklocation _joinNetworkLocation �g n  o  �f�f "0 networklocation networkLocation o  �e�e 0 fullurlrecord fullURLRecord�g  �h   o      �d�d "0 networklocation networkLocation�t  � Q  5	 r  

 c   n  o  �c�c "0 networklocation networkLocation o  �b�b 0 fullurlrecord fullURLRecord m  �a
�a 
ctxt o      �`�` "0 networklocation networkLocation R      �_�^
�_ .ascrerr ****      � ****�^   �]�\
�] 
errn d       m      �[�[��\  	 n "5 I  '5�Z�Y�Z .0 throwinvalidparameter throwInvalidParameter  o  '(�X�X 0 	urlrecord 	urlRecord  m  (+ �    m  +,�W
�W 
reco �V m  ,/ �   ~ U R L   c o m p o n e n t s   r e c o r d  s    n e t w o r k L o c a t i o n    p r o p e r t y   i s   n o t   t e x t .�V  �Y   o  "'�U�U 0 _support  � !"! l 6C#$%# r  6C&'& I 6A�T()
�T .Web:EscUnull���     ctxt( o  67�S�S 0 resourcepath resourcePath) �R*�Q
�R 
Safe* m  :=++ �,,  /�Q  ' o      �P�P 0 resourcepath resourcePath$ s m `split URL` (i.e. NSURL) automatically decodes % escapes in resource path, so automatically encode them here   % �-- �   ` s p l i t   U R L `   ( i . e .   N S U R L )   a u t o m a t i c a l l y   d e c o d e s   %   e s c a p e s   i n   r e s o u r c e   p a t h ,   s o   a u t o m a t i c a l l y   e n c o d e   t h e m   h e r e" ./. Z  D�01�O20 G  Dp343 > DI565 o  DE�N�N "0 networklocation networkLocation6 m  EH77 �88  4 l Ll9�M�L9 F  Ll:;: F  L_<=< > LQ>?> o  LM�K�K 0 	urlscheme 	urlScheme? m  MP@@ �AA  = E T[BCB o  TY�J�J 0 _usesnetloc _usesNetLocC o  YZ�I�I 0 	urlscheme 	urlScheme; H  bhDD C  bgEFE o  bc�H�H 0 resourcepath resourcePathF m  cfGG �HH  / /�M  �L  1 l s�IJKI k  s�LL MNM Z s�OP�G�FO F  s�QRQ > sxSTS o  st�E�E 0 resourcepath resourcePathT m  twUU �VV  R H  {�WW C  {�XYX o  {|�D�D 0 resourcepath resourcePathY m  |ZZ �[[  /P r  ��\]\ b  ��^_^ m  ��`` �aa  /_ o  ���C�C 0 resourcepath resourcePath] o      �B�B 0 resourcepath resourcePath�G  �F  N b�Ab r  ��cdc b  ��efe b  ��ghg m  ��ii �jj  / /h o  ���@�@ "0 networklocation networkLocationf o  ���?�? 0 resourcepath resourcePathd o      �>�> 0 urltext urlText�A  J / ) copied from Python's urllib.parse module   K �kk R   c o p i e d   f r o m   P y t h o n ' s   u r l l i b . p a r s e   m o d u l e�O  2 r  ��lml o  ���=�= 0 resourcepath resourcePathm o      �<�< 0 urltext urlText/ non Z ��pq�;�:p > ��rsr o  ���9�9 0 	urlscheme 	urlSchemes m  ��tt �uu  q r  ��vwv b  ��xyx b  ��z{z o  ���8�8 0 	urlscheme 	urlScheme{ m  ��|| �}}  :y o  ���7�7 0 urltext urlTextw o      �6�6 0 urltext urlText�;  �:  o ~~ Z �����5�4� > ����� o  ���3�3 "0 parameterstring parameterString� m  ���� ���  � r  ����� b  ����� b  ����� o  ���2�2 0 urltext urlText� m  ���� ���  ;� o  ���1�1 "0 parameterstring parameterString� o      �0�0 0 urltext urlText�5  �4   ��� Z �����/�.� > ����� o  ���-�- 0 querystring queryString� m  ���� ���  � r  ����� b  ����� b  ����� o  ���,�, 0 urltext urlText� m  ���� ���  ?� o  ���+�+ 0 querystring queryString� o      �*�* 0 urltext urlText�/  �.  � ��)� Z �����(�'� > ����� o  ���&�& (0 fragmentidentifier fragmentIdentifier� m  ���� ���  � r  ����� b  ����� b  ����� o  ���%�% 0 urltext urlText� m  ���� ���  #� o  ���$�$ (0 fragmentidentifier fragmentIdentifier� o      �#�# 0 urltext urlText�(  �'  �)  ��  [ l ����� r  ���� n ���� I  �"��!�" "0 astextparameter asTextParameter� ��� o  � �  0 	urlrecord 	urlRecord� ��� m  �� ���  �  �!  � o  ��� 0 _support  � o      �� 0 urltext urlText� M G assume it's a relative URL string that's going to be joined to baseURL   � ��� �   a s s u m e   i t ' s   a   r e l a t i v e   U R L   s t r i n g   t h a t ' s   g o i n g   t o   b e   j o i n e d   t o   b a s e U R LX ��� Z  `����� > ��� o  �� 0 baseurl baseURL� m  �� ���  � k  \�� ��� r  %��� n #��� I  #���� $0 asnsurlparameter asNSURLParameter� ��� o  �� 0 baseurl baseURL� ��� m  �� ���  u s i n g   b a s e   U R L�  �  � o  �� 0 _support  � o      �� 0 baseurl baseURL� ��� r  &5��� n &3��� I  -3���� <0 urlwithstring_relativetourl_ URLWithString_relativeToURL_� ��� o  -.�� 0 urltext urlText� ��� o  ./�� 0 baseurl baseURL�  �  � n &-��� o  )-�� 0 nsurl NSURL� m  &)�
� misccura� o      �� 0 asocurl asocURL� ��� Z 6T����
� = 6;��� o  67�	�	 0 asocurl asocURL� m  7:�
� 
msng� R  >P���
� .ascrerr ****      � ****� m  LO�� ���   N o t   a   v a l i d   U R L .� ���
� 
errn� m  BE���Y� ���
� 
erob� o  HI�� 0 urltext urlText�  �  �
  � ��� r  U\��� c  UZ��� o  UV� �  0 asocurl asocURL� m  VY��
�� 
ctxt� o      ���� 0 urltext urlText�  �  �  � ���� L  ac�� o  ab���� 0 urltext urlText��  T ���
�� conscase� ���
�� consdiac� ���
�� conshyph� ���
�� conspunc� ����
�� conswhit��  U ����
�� consnume��  Q R      ����
�� .ascrerr ****      � ****� o      ���� 0 etext eText� ����
�� 
errn� o      ���� 0 enumber eNumber� ����
�� 
erob� o      ���� 0 efrom eFrom� �����
�� 
errt� o      ���� 
0 eto eTo��  R I  l|������� 
0 _error  � ��� m  mp�� ���  j o i n   U R L�    o  pq���� 0 etext eText  o  qr���� 0 enumber eNumber  o  rs���� 0 efrom eFrom �� o  sv���� 
0 eto eTo��  ��  N S M TO DO: if baseURL is given, direct parameter should be either record or text   O � �   T O   D O :   i f   b a s e U R L   i s   g i v e n ,   d i r e c t   p a r a m e t e r   s h o u l d   b e   e i t h e r   r e c o r d   o r   t e x tB 	 l     ��������  ��  ��  	 

 l     ��������  ��  ��    l     ����   J D--------------------------------------------------------------------    � � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  l     ����   7 1 encode/decode '%XX' escapes (UTF8 encoding only)    � b   e n c o d e / d e c o d e   ' % X X '   e s c a p e s   ( U T F 8   e n c o d i n g   o n l y )  l     ��������  ��  ��    l      ����  `Z From RFC2396:
	
   2.3. Unreserved Characters

   Data characters that are allowed in a URI but do not have a reserved
   purpose are called unreserved.  These include upper and lower case
   letters, decimal digits, and a limited set of punctuation marks and
   symbols.

      --unreserved  = alphanum | mark

      --mark        = "-" | "_" | "." | "!" | "~" | "*" | "'" | "(" | ")"

   Unreserved characters can be escaped without changing the semantics
   of the URI, but this should not be done unless the URI is being used
   in a context that does not allow the unescaped character to appear.
    ��   F r o m   R F C 2 3 9 6 : 
 	 
       2 . 3 .   U n r e s e r v e d   C h a r a c t e r s 
 
       D a t a   c h a r a c t e r s   t h a t   a r e   a l l o w e d   i n   a   U R I   b u t   d o   n o t   h a v e   a   r e s e r v e d 
       p u r p o s e   a r e   c a l l e d   u n r e s e r v e d .     T h e s e   i n c l u d e   u p p e r   a n d   l o w e r   c a s e 
       l e t t e r s ,   d e c i m a l   d i g i t s ,   a n d   a   l i m i t e d   s e t   o f   p u n c t u a t i o n   m a r k s   a n d 
       s y m b o l s . 
 
             - - u n r e s e r v e d     =   a l p h a n u m   |   m a r k 
 
             - - m a r k                 =   " - "   |   " _ "   |   " . "   |   " ! "   |   " ~ "   |   " * "   |   " ' "   |   " ( "   |   " ) " 
 
       U n r e s e r v e d   c h a r a c t e r s   c a n   b e   e s c a p e d   w i t h o u t   c h a n g i n g   t h e   s e m a n t i c s 
       o f   t h e   U R I ,   b u t   t h i s   s h o u l d   n o t   b e   d o n e   u n l e s s   t h e   U R I   i s   b e i n g   u s e d 
       i n   a   c o n t e x t   t h a t   d o e s   n o t   a l l o w   t h e   u n e s c a p e d   c h a r a c t e r   t o   a p p e a r . 
  l     ��������  ��  ��     l     ��!"��  ! � � set of characters that never need encoded (copied from Python's urllib.parse module); used by escape URL characters as base character set -- TO DO: any reason why urllib doesn't allow all of the above punctuation chars   " �##�   s e t   o f   c h a r a c t e r s   t h a t   n e v e r   n e e d   e n c o d e d   ( c o p i e d   f r o m   P y t h o n ' s   u r l l i b . p a r s e   m o d u l e ) ;   u s e d   b y   e s c a p e   U R L   c h a r a c t e r s   a s   b a s e   c h a r a c t e r   s e t   - -   T O   D O :   a n y   r e a s o n   w h y   u r l l i b   d o e s n ' t   a l l o w   a l l   o f   t h e   a b o v e   p u n c t u a t i o n   c h a r s  $%$ j   _ c��&�� "0 _safecharacters _safeCharacters& m   _ b'' �(( � a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 0 1 2 3 4 5 6 7 8 9 - _ .% )*) l     ��������  ��  ��  * +,+ l     ��������  ��  ��  , -.- i  d g/0/ I      ��1���� 0 _replacetext _replaceText1 232 o      ���� 0 thetext theText3 454 o      ���� 0 fromtext fromText5 6��6 o      ���� 0 totext toText��  ��  0 k     77 898 r     :;: o     ���� 0 fromtext fromText; n     <=< 1    ��
�� 
txdl= 1    ��
�� 
ascr9 >?> r    @A@ n   	BCB 2   	��
�� 
citmC o    ���� 0 thetext theTextA o      ���� 0 thelist theList? DED r    FGF o    ���� 0 totext toTextG n     HIH 1    ��
�� 
txdlI 1    ��
�� 
ascrE J��J L    KK c    LML o    ���� 0 thelist theListM m    ��
�� 
ctxt��  . NON l     ��������  ��  ��  O PQP l     ��������  ��  ��  Q RSR l     ��TU��  T  -----   U �VV 
 - - - - -S WXW l     ��������  ��  ��  X YZY i  h k[\[ I     ��]^
�� .Web:EscUnull���     ctxt] o      ���� 0 thetext theText^ ��_��
�� 
Safe_ |����`��a��  ��  ` o      ���� &0 allowedcharacters allowedCharacters��  a l     b����b m      cc �dd  ��  ��  ��  \ Q     oefge k    Yhh iji r    klk n   mnm I    ��o���� "0 astextparameter asTextParametero pqp o    	���� 0 thetext theTextq r��r m   	 
ss �tt  ��  ��  n o    ���� 0 _support  l o      ���� 0 thetext theTextj uvu r    $wxw b    "yzy o    ���� "0 _safecharacters _safeCharactersz n   !{|{ I    !��}���� "0 astextparameter asTextParameter} ~~ o    ���� &0 allowedcharacters allowedCharacters ���� m    �� ���  p r e s e r v i n g��  ��  | o    ���� 0 _support  x o      ���� &0 allowedcharacters allowedCharactersv ��� r   % /��� n  % -��� I   ( -������� J0 #charactersetwithcharactersinstring_ #characterSetWithCharactersInString_� ���� o   ( )���� &0 allowedcharacters allowedCharacters��  ��  � n  % (��� o   & (����  0 nscharacterset NSCharacterSet� m   % &��
�� misccura� o      ���� $0 asocallowedchars asocAllowedChars� ��� l  0 A���� r   0 A��� n  0 ?��� I   : ?������� j0 3stringbyaddingpercentencodingwithallowedcharacters_ 3stringByAddingPercentEncodingWithAllowedCharacters_� ���� o   : ;���� $0 asocallowedchars asocAllowedChars��  ��  � n  0 :��� I   5 :������� 0 
asnsstring 
asNSString� ���� o   5 6���� 0 thetext theText��  ��  � o   0 5���� 0 _support  � o      ���� 0 
asocresult 
asocResult��� Returns a new string made from the receiver by replacing all characters not in the allowedCharacters set with percent encoded characters. UTF-8 encoding is used to determine the correct percent encoded characters. Entire URL strings cannot be percent-encoded. This method is intended to percent-encode an URL component or subcomponent string, NOT the entire URL string. Any characters in allowedCharacters outside of the 7-bit ASCII range are ignored.   � ����   R e t u r n s   a   n e w   s t r i n g   m a d e   f r o m   t h e   r e c e i v e r   b y   r e p l a c i n g   a l l   c h a r a c t e r s   n o t   i n   t h e   a l l o w e d C h a r a c t e r s   s e t   w i t h   p e r c e n t   e n c o d e d   c h a r a c t e r s .   U T F - 8   e n c o d i n g   i s   u s e d   t o   d e t e r m i n e   t h e   c o r r e c t   p e r c e n t   e n c o d e d   c h a r a c t e r s .   E n t i r e   U R L   s t r i n g s   c a n n o t   b e   p e r c e n t - e n c o d e d .   T h i s   m e t h o d   i s   i n t e n d e d   t o   p e r c e n t - e n c o d e   a n   U R L   c o m p o n e n t   o r   s u b c o m p o n e n t   s t r i n g ,   N O T   t h e   e n t i r e   U R L   s t r i n g .   A n y   c h a r a c t e r s   i n   a l l o w e d C h a r a c t e r s   o u t s i d e   o f   t h e   7 - b i t   A S C I I   r a n g e   a r e   i g n o r e d .� ��� l  B T���� Z  B T������� =  B E��� o   B C���� 0 
asocresult 
asocResult� m   C D��
�� 
msng� R   H P����
�� .ascrerr ****      � ****� m   N O�� ��� ^ C o u l d n ' t   c o n v e r t   c h a r a c t e r s   t o   p e r c e n t   e s c a p e s .� ����
�� 
errn� m   J K�����Y� �����
�� 
erob� o   L M�� 0 thetext theText��  ��  ��  � , & NSString docs are hopeless on details   � ��� L   N S S t r i n g   d o c s   a r e   h o p e l e s s   o n   d e t a i l s� ��~� L   U Y�� c   U X��� o   U V�}�} 0 
asocresult 
asocResult� m   V W�|
�| 
ctxt�~  f R      �{��
�{ .ascrerr ****      � ****� o      �z�z 0 etext eText� �y��
�y 
errn� o      �x�x 0 enumber eNumber� �w��
�w 
erob� o      �v�v 0 efrom eFrom� �u��t
�u 
errt� o      �s�s 
0 eto eTo�t  g I   a o�r��q�r 
0 _error  � ��� m   b e�� ��� * e n c o d e   U R L   c h a r a c t e r s� ��� o   e f�p�p 0 etext eText� ��� o   f g�o�o 0 enumber eNumber� ��� o   g h�n�n 0 efrom eFrom� ��m� o   h i�l�l 
0 eto eTo�m  �q  Z ��� l     �k�j�i�k  �j  �i  � ��� l     �h�g�f�h  �g  �f  � ��� i  l o��� I     �e��d
�e .Web:UneUnull���     ctxt� o      �c�c 0 thetext theText�d  � Q     K���� k    9�� ��� r    ��� n   ��� I    �b��a�b "0 astextparameter asTextParameter� ��� o    	�`�` 0 thetext theText� ��_� m   	 
�� ���  �_  �a  � o    �^�^ 0 _support  � o      �]�] 0 thetext theText� ��� l   !���� r    !��� n   ��� I    �\�[�Z�\ B0 stringbyremovingpercentencoding stringByRemovingPercentEncoding�[  �Z  � n   ��� I    �Y��X�Y 0 
asnsstring 
asNSString� ��W� o    �V�V 0 thetext theText�W  �X  � o    �U�U 0 _support  � o      �T�T 0 
asocresult 
asocResult� � � Returns a new string made from the receiver by replacing all percent encoded sequences with the matching UTF-8 characters. (NSURLUtilites, 10.9+)   � ���$   R e t u r n s   a   n e w   s t r i n g   m a d e   f r o m   t h e   r e c e i v e r   b y   r e p l a c i n g   a l l   p e r c e n t   e n c o d e d   s e q u e n c e s   w i t h   t h e   m a t c h i n g   U T F - 8   c h a r a c t e r s .   ( N S U R L U t i l i t e s ,   1 0 . 9 + )� ��� Z  " 4���S�R� =  " %��� o   " #�Q�Q 0 
asocresult 
asocResult� m   # $�P
�P 
msng� R   ( 0�O��
�O .ascrerr ****      � ****� m   . /�� ��� � C o u l d n ' t   c o n v e r t   p e r c e n t   e s c a p e s   t o   c h a r a c t e r s   ( e . g .   n o t   v a l i d   U T F 8 ) .� �N��
�N 
errn� m   * +�M�M�Y� �L��K
�L 
erob� o   , -�J�J 0 thetext theText�K  �S  �R  � ��I� L   5 9�� c   5 8��� o   5 6�H�H 0 
asocresult 
asocResult� m   6 7�G
�G 
ctxt�I  � R      �F��
�F .ascrerr ****      � ****� o      �E�E 0 etext eText� �D� 
�D 
errn� o      �C�C 0 enumber eNumber  �B
�B 
erob o      �A�A 0 efrom eFrom �@�?
�@ 
errt o      �>�> 
0 eto eTo�?  � I   A K�=�<�= 
0 _error    m   B C � * d e c o d e   U R L   c h a r a c t e r s 	
	 o   C D�;�; 0 etext eText
  o   D E�:�: 0 enumber eNumber  o   E F�9�9 0 efrom eFrom �8 o   F G�7�7 
0 eto eTo�8  �<  �  l     �6�5�4�6  �5  �4    l     �3�2�1�3  �2  �1    l     �0�0   J D--------------------------------------------------------------------    � � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  l     �/�/   � � parse and format "key1=value1&key2=value2&..." query strings or 'application/x-www-form-urlencoded' data as {{"KEY","VALUE"},...} list    �   p a r s e   a n d   f o r m a t   " k e y 1 = v a l u e 1 & k e y 2 = v a l u e 2 & . . . "   q u e r y   s t r i n g s   o r   ' a p p l i c a t i o n / x - w w w - f o r m - u r l e n c o d e d '   d a t a   a s   { { " K E Y " , " V A L U E " } , . . . }   l i s t  l     �.�-�,�.  �-  �,    !  i  p s"#" I     �+$�*
�+ .Web:SplQnull���     ctxt$ o      �)�) 0 	querytext 	queryText�*  # P     �%&'% k    �(( )*) r    
+,+ n   -.- 1    �(
�( 
txdl. 1    �'
�' 
ascr, o      �&�& 0 oldtids oldTIDs* /�%/ Q    �0120 k    �33 454 r    "676 I     �$8�#�$ 0 _replacetext _replaceText8 9:9 n   ;<; I    �"=�!�" "0 astextparameter asTextParameter= >?> o    � �  0 	querytext 	queryText? @�@ m    AA �BB  �  �!  < o    �� 0 _support  : CDC m    EE �FF  +D G�G 1    �
� 
spac�  �#  7 o      �� 0 	querytext 	queryText5 HIH r   # (JKJ m   # $LL �MM  &K n     NON 1   % '�
� 
txdlO 1   $ %�
� 
ascrI PQP r   ) .RSR n  ) ,TUT 2  * ,�
� 
citmU o   ) *�� 0 	querytext 	queryTextS o      �� 0 	querylist 	queryListQ VWV r   / 4XYX m   / 0ZZ �[[  =Y n     \]\ 1   1 3�
� 
txdl] 1   0 1�
� 
ascrW ^_^ X   5 �`�a` k   E �bb cdc r   E Mefe n   E Kghg 2  I K�
� 
citmh l  E Ii��i e   E Ijj n  E Iklk 1   F H�
� 
pcntl o   E F�� 0 aref aRef�  �  f o      �� 0 
queryparts 
queryPartsd mnm l  N nopqo Z  N nrs��r >   N Utut n   N Svwv 1   O S�

�
 
lengw o   N O�	�	 0 
queryparts 
queryPartsu m   S T�� s R   X j�xy
� .ascrerr ****      � ****x m   f izz �{{ * I n v a l i d   q u e r y   s t r i n g .y �|}
� 
errn| m   \ _���Y} �~�
� 
erob~ o   b c�� 0 	querytext 	queryText�  �  �  p h b TO DO: implement 'without strict parsing' option, in which case missing `=` wouldn't throw error?   q � �   T O   D O :   i m p l e m e n t   ' w i t h o u t   s t r i c t   p a r s i n g '   o p t i o n ,   i n   w h i c h   c a s e   m i s s i n g   ` = `   w o u l d n ' t   t h r o w   e r r o r ?n ��� l  o o����  � N H TO DO: what if key is empty string? error here, or leave it for caller?   � ��� �   T O   D O :   w h a t   i f   k e y   i s   e m p t y   s t r i n g ?   e r r o r   h e r e ,   o r   l e a v e   i t   f o r   c a l l e r ?� �� � r   o ���� J   o ��� ��� I  o w�����
�� .Web:UneUnull���     ctxt� l  o s������ n   o s��� 4   p s���
�� 
cobj� m   q r���� � o   o p���� 0 
queryparts 
queryParts��  ��  ��  � ���� I  w �����
�� .Web:UneUnull���     ctxt� l  w {������ n   w {��� 4   x {���
�� 
cobj� m   y z���� � o   w x���� 0 
queryparts 
queryParts��  ��  ��  ��  � n     ��� 1   � ���
�� 
pcnt� o   � ����� 0 aref aRef�   � 0 aref aRefa o   8 9���� 0 	querylist 	queryList_ ��� r   � ���� o   � ����� 0 oldtids oldTIDs� n     ��� 1   � ���
�� 
txdl� 1   � ���
�� 
ascr� ���� L   � ��� o   � ����� 0 	querylist 	queryList��  1 R      ����
�� .ascrerr ****      � ****� o      ���� 0 etext eText� ����
�� 
errn� o      ���� 0 enumber eNumber� ����
�� 
erob� o      ���� 0 efrom eFrom� �����
�� 
errt� o      ���� 
0 eto eTo��  2 k   � ��� ��� r   � ���� o   � ����� 0 oldtids oldTIDs� n     ��� 1   � ���
�� 
txdl� 1   � ���
�� 
ascr� ���� I   � �������� 
0 _error  � ��� m   � ��� ��� , s p l i t   U R L   q u e r y   s t r i n g� ��� o   � ����� 0 etext eText� ��� o   � ����� 0 enumber eNumber� ��� o   � ����� 0 efrom eFrom� ���� o   � ����� 
0 eto eTo��  ��  ��  �%  & ���
�� conscase� ���
�� consdiac� ���
�� conshyph� ���
�� conspunc� ����
�� conswhit��  ' ����
�� consnume��  ! ��� l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� i  t w��� I     �����
�� .Web:JoiQnull���     ****� o      ���� 0 	querylist 	queryList��  � k     ��� ��� r     ��� n    ��� 1    ��
�� 
txdl� 1     ��
�� 
ascr� o      ���� 0 oldtids oldTIDs� ���� Q    ����� k   	 ��� ��� r   	 ��� n  	 ��� 2   ��
�� 
cobj� n  	 ��� I    ������� 0 aslist asList� ��� o    ���� 0 	querylist 	queryList� ���� m    �� ���  ��  ��  � o   	 ���� 0 _support  � o      ���� 0 	querylist 	queryList� ��� X    ������ k   ) ��� ��� r   ) .��� n  ) ,��� 1   * ,��
�� 
pcnt� o   ) *���� 0 aref aRef� o      ���� 0 kvpair kvPair� ��� Z  / T������� F   / E��� H   / ;�� =   / :��� l  / 8������ I  / 8����
�� .corecnte****       ****� J   / 2�� ���� o   / 0���� 0 kvpair kvPair��  � �����
�� 
kocl� m   3 4��
�� 
list��  ��  ��  � m   8 9���� � =   > C��� n  > A��� 1   ? A��
�� 
leng� o   > ?���� 0 kvpair kvPair� m   A B���� � R   H P�� 
�� .ascrerr ****      � ****  m   N O � l I n v a l i d   q u e r y   l i s t   ( n o t   a   l i s t   o f   k e y - v a l u e   s u b l i s t s ) . ��
�� 
errn m   J K�����Y ����
�� 
erob o   L M���� 0 aref aRef��  ��  ��  �  Z   U r	
����	 H   U a =   U ` l  U ^���� I  U ^��
�� .corecnte****       **** o   U V���� 0 kvpair kvPair ����
�� 
kocl m   W Z��
�� 
ctxt��  ��  ��   m   ^ _���� 
 R   d n��
�� .ascrerr ****      � **** m   j m � d I n v a l i d   q u e r y   l i s t   ( k e y s   a n d   v a l u e s   m u s t   b e   t e x t ) . ��
�� 
errn m   f g�����Y ����
�� 
erob o   h i���� 0 aref aRef��  ��  ��   �� r   s � I   s ������� 0 _replacetext _replaceText  b   t �  b   t �!"! l  t �#����# I  t ���$%
�� .Web:EscUnull���     ctxt$ l  t x&����& n  t x'(' 4   u x��)
�� 
cobj) m   v w���� ( o   t u���� 0 kvpair kvPair��  ��  % ��*��
�� 
Safe* 1   { ~��
�� 
spac��  ��  ��  " m   � �++ �,,  =  l  � �-����- I  � ���./
�� .Web:EscUnull���     ctxt. l  � �0��~0 n  � �121 4   � ��}3
�} 
cobj3 m   � ��|�| 2 o   � ��{�{ 0 kvpair kvPair�  �~  / �z4�y
�z 
Safe4 1   � ��x
�x 
spac�y  ��  ��   565 1   � ��w
�w 
spac6 7�v7 m   � �88 �99  +�v  ��   n     :;: 1   � ��u
�u 
pcnt; o   � ��t�t 0 aref aRef��  �� 0 aref aRef� o    �s�s 0 	querylist 	queryList� <=< r   � �>?> m   � �@@ �AA  &? n     BCB 1   � ��r
�r 
txdlC 1   � ��q
�q 
ascr= DED r   � �FGF c   � �HIH o   � ��p�p 0 	querylist 	queryListI m   � ��o
�o 
ctxtG o      �n�n 0 	querytext 	queryTextE JKJ r   � �LML o   � ��m�m 0 oldtids oldTIDsM n     NON 1   � ��l
�l 
txdlO 1   � ��k
�k 
ascrK P�jP L   � �QQ o   � ��i�i 0 	querytext 	queryText�j  � R      �hRS
�h .ascrerr ****      � ****R o      �g�g 0 etext eTextS �fTU
�f 
errnT o      �e�e 0 enumber eNumberU �dVW
�d 
erobV o      �c�c 0 efrom eFromW �bX�a
�b 
errtX o      �`�` 
0 eto eTo�a  � k   � �YY Z[Z r   � �\]\ o   � ��_�_ 0 oldtids oldTIDs] n     ^_^ 1   � ��^
�^ 
txdl_ 1   � ��]
�] 
ascr[ `�\` I   � ��[a�Z�[ 
0 _error  a bcb m   � �dd �ee * j o i n   U R L   q u e r y   s t r i n gc fgf o   � ��Y�Y 0 etext eTextg hih o   � ��X�X 0 enumber eNumberi jkj o   � ��W�W 0 efrom eFromk l�Vl o   � ��U�U 
0 eto eTo�V  �Z  �\  ��  � mnm l     �T�S�R�T  �S  �R  n opo l     �Q�P�O�Q  �P  �O  p qrq l     �Nst�N  s J D--------------------------------------------------------------------   t �uu � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -r vwv l     �Mxy�M  x , & encode/decode AS objects as JSON data   y �zz L   e n c o d e / d e c o d e   A S   o b j e c t s   a s   J S O N   d a t aw {|{ l     �L�K�J�L  �K  �J  | }~} i  x {� I     �I��
�I .Web:FJSNnull���     ****� o      �H�H 0 
jsonobject 
jsonObject� �G��F
�G 
EWSp� |�E�D��C��E  �D  � o      �B�B "0 isprettyprinted isPrettyPrinted�C  � l     ��A�@� m      �?
�? boovfals�A  �@  �F  � Q     ����� k    ��� ��� Z    ���>�� n   ��� I    �=��<�= (0 asbooleanparameter asBooleanParameter� ��� o    	�;�; "0 isprettyprinted isPrettyPrinted� ��:� m   	 
�� ��� " e x t r a   w h i t e   s p a c e�:  �<  � o    �9�9 0 _support  � r    ��� n   ��� o    �8�8 80 nsjsonwritingprettyprinted NSJSONWritingPrettyPrinted� m    �7
�7 misccura� o      �6�6 0 writeoptions writeOptions�>  � r    ��� m    �5�5  � o      �4�4 0 writeoptions writeOptions� ��� Z    5���3�2� H    &�� l   %��1�0� n   %��� I     %�/��.�/ (0 isvalidjsonobject_ isValidJSONObject_� ��-� o     !�,�, 0 
jsonobject 
jsonObject�-  �.  � n    ��� o     �+�+ *0 nsjsonserialization NSJSONSerialization� m    �*
�* misccura�1  �0  � R   ) 1�)��
�) .ascrerr ****      � ****� m   / 0�� ��� z C a n  t   c o n v e r t   o b j e c t   t o   J S O N   ( f o u n d   u n s u p p o r t e d   o b j e c t   t y p e ) .� �(��
�( 
errn� m   + ,�'�'�Y� �&��%
�& 
erob� o   - .�$�$ 0 
jsonobject 
jsonObject�%  �3  �2  � ��� r   6 O��� n  6 @��� I   9 @�#��"�# F0 !datawithjsonobject_options_error_ !dataWithJSONObject_options_error_� ��� o   9 :�!�! 0 
jsonobject 
jsonObject� ��� o   : ;� �  0 writeoptions writeOptions� ��� l  ; <���� m   ; <�
� 
obj �  �  �  �"  � n  6 9��� o   7 9�� *0 nsjsonserialization NSJSONSerialization� m   6 7�
� misccura� J      �� ��� o      �� 0 thedata theData� ��� o      �� 0 theerror theError�  � ��� Z  P l����� =  P S��� o   P Q�� 0 thedata theData� m   Q R�
� 
msng� R   V h���
� .ascrerr ****      � ****� b   \ g��� b   \ c��� m   \ ]�� ��� : C a n  t   c o n v e r t   o b j e c t   t o   J S O N (� n  ] b��� I   ^ b���� ,0 localizeddescription localizedDescription�  �  � o   ] ^�� 0 theerror theError� m   c f�� ���  ) .� ���
� 
errn� m   X Y���Y� ���

� 
erob� o   Z [�	�	 0 
jsonobject 
jsonObject�
  �  �  � ��� L   m ��� c   m ���� l  m ����� n  m ���� I   v ����� 00 initwithdata_encoding_ initWithData_encoding_� ��� o   v w�� 0 thedata theData� ��� l  w |��� � n  w |��� o   x |���� ,0 nsutf8stringencoding NSUTF8StringEncoding� m   w x��
�� misccura�  �   �  �  � n  m v��� I   r v�������� 	0 alloc  ��  ��  � n  m r��� o   n r���� 0 nsstring NSString� m   m n��
�� misccura�  �  � m   � ���
�� 
ctxt�  � R      ����
�� .ascrerr ****      � ****� o      ���� 0 etext eText� ����
�� 
errn� o      ���� 0 enumber eNumber� ����
�� 
erob� o      ���� 0 efrom eFrom� �����
�� 
errt� o      ���� 
0 eto eTo��  � I   � �������� 
0 _error  � ��� m   � ��� ���  e n c o d e   J S O N� ��� o   � ����� 0 etext eText� ��� o   � ����� 0 enumber eNumber� ��� o   � ����� 0 efrom eFrom� ���� o   � ����� 
0 eto eTo��  ��  ~ ��� l     ��������  ��  ��  �    l     ��������  ��  ��    i  |  I     ��
�� .Web:PJSNnull���     ctxt o      ���� 0 jsontext jsonText ����
�� 
Frag |����	��
��  ��  	 o      ���� *0 arefragmentsallowed areFragmentsAllowed��  
 l     ���� m      ��
�� boovfals��  ��  ��   Q     � k    �  r     n    I    ������ "0 astextparameter asTextParameter  o    	���� 0 jsontext jsonText �� m   	 
 �  ��  ��   o    ���� 0 _support   o      ���� 0 jsontext jsonText  Z    *��  n   !"! I    ��#���� (0 asbooleanparameter asBooleanParameter# $%$ o    ���� *0 arefragmentsallowed areFragmentsAllowed% &��& m    '' �(( $ a l l o w i n g   f r a g m e n t s��  ��  " o    ���� 0 _support   r    $)*) n   "+,+ o     "���� :0 nsjsonreadingallowfragments NSJSONReadingAllowFragments, m     ��
�� misccura* o      ���� 0 readoptions readOptions��    r   ' *-.- m   ' (����  . o      ���� 0 readoptions readOptions /0/ r   + >121 n  + <343 I   5 <��5���� (0 datausingencoding_ dataUsingEncoding_5 6��6 l  5 87����7 n  5 8898 o   6 8���� ,0 nsutf8stringencoding NSUTF8StringEncoding9 m   5 6��
�� misccura��  ��  ��  ��  4 n  + 5:;: I   0 5��<���� 0 
asnsstring 
asNSString< =��= o   0 1���� 0 jsontext jsonText��  ��  ; o   + 0���� 0 _support  2 o      ���� 0 thedata theData0 >?> r   ? X@A@ n  ? IBCB I   B I��D���� F0 !jsonobjectwithdata_options_error_ !JSONObjectWithData_options_error_D EFE o   B C���� 0 thedata theDataF GHG o   C D���� 0 readoptions readOptionsH I��I l  D EJ����J m   D E��
�� 
obj ��  ��  ��  ��  C n  ? BKLK o   @ B���� *0 nsjsonserialization NSJSONSerializationL m   ? @��
�� misccuraA J      MM NON o      ���� 0 
jsonobject 
jsonObjectO P��P o      ���� 0 theerror theError��  ? QRQ Z  Y {ST����S =  Y \UVU o   Y Z���� 0 
jsonobject 
jsonObjectV m   Z [��
�� 
msngT R   _ w��WX
�� .ascrerr ****      � ****W b   i vYZY b   i r[\[ m   i l]] �^^   N o t   v a l i d   J S O N   (\ n  l q_`_ I   m q�������� ,0 localizeddescription localizedDescription��  ��  ` o   l m���� 0 theerror theErrorZ m   r uaa �bb  ) .X ��cd
�� 
errnc m   a b�����Yd ��e��
�� 
erobe o   e f���� 0 jsontext jsonText��  ��  ��  R f��f L   | �gg c   | �hih o   | }���� 0 
jsonobject 
jsonObjecti m   } ���
�� 
****��   R      ��jk
�� .ascrerr ****      � ****j o      ���� 0 etext eTextk ��lm
�� 
errnl o      ���� 0 enumber eNumberm ��no
�� 
erobn o      ���� 0 efrom eFromo ��p��
�� 
errtp o      ���� 
0 eto eTo��   I   � ���q���� 
0 _error  q rsr m   � �tt �uu  d e c o d e   J S O Ns vwv o   � ����� 0 etext eTextw xyx o   � ����� 0 enumber eNumbery z{z o   � ����� 0 efrom eFrom{ |��| o   � ����� 
0 eto eTo��  ��   }~} l     ��������  ��  ��  ~ � l     ��������  ��  ��  � ��� l     ��������  ��  ��  � ��� i  � ���� I     �����
�� .Web:FB64null���     ctxt� o      �� 0 thetext theText��  � Q     :���� k    (�� ��� r    ��� n   ��� I    �~��}�~ 0 
asnsstring 
asNSString� ��|� n   ��� I    �{��z�{ "0 astextparameter asTextParameter� ��� o    �y�y 0 thetext theText� ��x� m    �� ���  �x  �z  � o    �w�w 0 _support  �|  �}  � o    �v�v 0 _support  � o      �u�u 0 
asocstring 
asocString� ��t� L    (�� n   '��� I    '�s��r�s (0 datausingencoding_ dataUsingEncoding_� ��q� l   #��p�o� n   #��� I    #�n��m�n B0 base64encodedstringwithoptions_ base64EncodedStringWithOptions_� ��l� m    �k�k  �l  �m  � l   ��j�i� n   ��� o    �h�h ,0 nsutf8stringencoding NSUTF8StringEncoding� m    �g
�g misccura�j  �i  �p  �o  �q  �r  � o    �f�f 0 
asocstring 
asocString�t  � R      �e��
�e .ascrerr ****      � ****� o      �d�d 0 etext eText� �c��
�c 
errn� o      �b�b 0 enumber eNumber� �a��
�a 
erob� o      �`�` 0 efrom eFrom� �_��^
�_ 
errt� o      �]�] 
0 eto eTo�^  � I   0 :�\��[�\ 
0 _error  � ��� m   1 2�� ���  e n c o d e   B a s e 6 4� ��� o   2 3�Z�Z 0 etext eText� ��� o   3 4�Y�Y 0 enumber eNumber� ��� o   4 5�X�X 0 efrom eFrom� ��W� o   5 6�V�V 
0 eto eTo�W  �[  � ��� l     �U�T�S�U  �T  �S  � ��� l     �R�Q�P�R  �Q  �P  � ��� i  � ���� I     �O��N
�O .Web:PB64null���     ctxt� o      �M�M 0 thetext theText�N  � Q     b���� k    L�� ��� r    ��� n   ��� I    �L��K�L "0 astextparameter asTextParameter� ��� o    	�J�J 0 thetext theText� ��I� m   	 
�� ���  �I  �K  � o    �H�H 0 _support  � o      �G�G 0 thetext theText� ��� l   "���� r    "��� n    ��� I     �F��E�F L0 $initwithbase64encodedstring_options_ $initWithBase64EncodedString_options_� ��� o    �D�D 0 thetext theText� ��C� l   ��B�A� n   ��� o    �@�@ Z0 +nsdatabase64decodingignoreunknowncharacters +NSDataBase64DecodingIgnoreUnknownCharacters� m    �?
�? misccura�B  �A  �C  �E  � n   ��� I    �>�=�<�> 	0 alloc  �=  �<  � n   ��� o    �;�; 0 nsdata NSData� m    �:
�: misccura� o      �9�9 0 asocdata asocData� � � ignores line breaks and other non-Base64 chars; TO DO: would it be better to strip white space chars separately, then fail if text contains any other non-Base64 chars   � ���N   i g n o r e s   l i n e   b r e a k s   a n d   o t h e r   n o n - B a s e 6 4   c h a r s ;   T O   D O :   w o u l d   i t   b e   b e t t e r   t o   s t r i p   w h i t e   s p a c e   c h a r s   s e p a r a t e l y ,   t h e n   f a i l   i f   t e x t   c o n t a i n s   a n y   o t h e r   n o n - B a s e 6 4   c h a r s� ��� r   # 4��� l  # 2��8�7� n  # 2��� I   * 2�6��5�6 00 initwithdata_encoding_ initWithData_encoding_� ��� o   * +�4�4 0 asocdata asocData� ��3� l  + .��2�1� n  + .��� o   , .�0�0 ,0 nsutf8stringencoding NSUTF8StringEncoding� m   + ,�/
�/ misccura�2  �1  �3  �5  � n  # *��� I   & *�.�-�,�. 	0 alloc  �-  �,  � n  # &��� o   $ &�+�+ 0 nsstring NSString� m   # $�*
�* misccura�8  �7  � o      �)�) 0 
asocstring 
asocString� ��(� Z  5 L���'�&� =  5 8   o   5 6�%�% 0 
asocstring 
asocString m   6 7�$
�$ 
msng� n  ; H I   @ H�#�"�# .0 throwinvalidparameter throwInvalidParameter  o   @ A�!�! 0 thetext theText  m   A B		 �

    m   B C� 
�  
ctxt � m   C D � l B a s e 6 4 - e n c o d e d   d a t a   d o e s n ' t   c o n t a i n   U T F 8 - e n c o d e d   t e x t .�  �"   o   ; @�� 0 _support  �'  �&  �(  � R      �
� .ascrerr ****      � **** o      �� 0 etext eText �
� 
errn o      �� 0 enumber eNumber �
� 
erob o      �� 0 efrom eFrom ��
� 
errt o      �� 
0 eto eTo�  � I   T b��� 
0 _error    m   U X �  d e c o d e   B a s e 6 4  o   X Y�� 0 etext eText  o   Y Z�� 0 enumber eNumber  !  o   Z [�� 0 efrom eFrom! "�" o   [ \�� 
0 eto eTo�  �  � #$# l     ����  �  �  $ %&% l     �
�	��
  �	  �  & '(' l     �)*�  ) J D--------------------------------------------------------------------   * �++ � - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -( ,-, l     �./�  .   HTTP dispatch   / �00    H T T P   d i s p a t c h- 121 l     ����  �  �  2 343 l     5675 j   � ��8� "0 _excludeheaders _excludeHeaders8 J   � �99 :;: m   � �<< �==  A u t h o r i z a t i o n; >?> m   � �@@ �AA  C o n n e c t i o n? BCB m   � �DD �EE  H o s tC FGF m   � �HH �II $ P r o x y - A u t h e n t i c a t eG JKJ m   � �LL �MM & P r o x y - A u t h o r i z a t i o nK NON m   � �PP �QQ   W W W - A u t h e n t i c a t eO R�R m   � �SS �TT  C o n t e n t - L e n g t h�  6 � � note: unlike authorization headers, "Content-Length" isn't reserved by NSSession but is already set automatically so no point allowing users to override with potentially wrong value   7 �UUl   n o t e :   u n l i k e   a u t h o r i z a t i o n   h e a d e r s ,   " C o n t e n t - L e n g t h "   i s n ' t   r e s e r v e d   b y   N S S e s s i o n   b u t   i s   a l r e a d y   s e t   a u t o m a t i c a l l y   s o   n o   p o i n t   a l l o w i n g   u s e r s   t o   o v e r r i d e   w i t h   p o t e n t i a l l y   w r o n g   v a l u e4 VWV l     � �����   ��  ��  W XYX l     ��������  ��  ��  Y Z[Z h   � ���\�� (0 _nsstringencodings _NSStringEncodings\ l     ]^_] k      `` aba l     ��cd��  c�� note: the right way to implement this would be to convert charset name to NSStringEncoding via CFStringConvertIANACharSetNameToEncoding and CFStringConvertEncodingToNSStringEncoding, but ASOC can't call CF APIs properly so all we can do here is define our own list of charset names (including variations) that map directly to available NSStringEncodings; user will have to work with NSData when dealing with any other encodings   d �eeX   n o t e :   t h e   r i g h t   w a y   t o   i m p l e m e n t   t h i s   w o u l d   b e   t o   c o n v e r t   c h a r s e t   n a m e   t o   N S S t r i n g E n c o d i n g   v i a   C F S t r i n g C o n v e r t I A N A C h a r S e t N a m e T o E n c o d i n g   a n d   C F S t r i n g C o n v e r t E n c o d i n g T o N S S t r i n g E n c o d i n g ,   b u t   A S O C   c a n ' t   c a l l   C F   A P I s   p r o p e r l y   s o   a l l   w e   c a n   d o   h e r e   i s   d e f i n e   o u r   o w n   l i s t   o f   c h a r s e t   n a m e s   ( i n c l u d i n g   v a r i a t i o n s )   t h a t   m a p   d i r e c t l y   t o   a v a i l a b l e   N S S t r i n g E n c o d i n g s ;   u s e r   w i l l   h a v e   t o   w o r k   w i t h   N S D a t a   w h e n   d e a l i n g   w i t h   a n y   o t h e r   e n c o d i n g sb fgf j     ��h�� 	0 _list  h m     ��
�� 
msngg iji l     ��������  ��  ��  j klk i   mnm I      �������� 	0 _init  ��  ��  n r    &opo J     qq rsr l 	   	t����t J     	uu vwv J     xx yzy m     {{ �|| 
 u t f - 8z }��} m    ~~ �  u t f 8��  w ���� n   ��� o    ���� ,0 nsutf8stringencoding NSUTF8StringEncoding� m    ��
�� misccura��  ��  ��  s ��� l 	 	 ������ J   	 �� ��� J   	 �� ��� m   	 
�� ���  u t f - 1 6� ���� m   
 �� ��� 
 u t f 1 6��  � ���� n   ��� o    ���� .0 nsutf16stringencoding NSUTF16StringEncoding� m    ��
�� misccura��  ��  ��  � ��� l 	  ������ J    �� ��� J    �� ��� m    �� ���  u t f - 1 6 b e� ���� m    �� ���  u t f 1 6 b e��  � ���� n   ��� o    ���� @0 nsutf16bigendianstringencoding NSUTF16BigEndianStringEncoding� m    ��
�� misccura��  ��  ��  � ��� l 	  $������ J    $�� ��� J    �� ��� m    �� ���  u t f - 1 6 l e� ���� m    �� ���  u t f 1 6 l e��  � ���� n   "��� o     "���� F0 !nsutf16littleendianstringencoding !NSUTF16LittleEndianStringEncoding� m     ��
�� misccura��  ��  ��  � ��� l 	 $ -������ J   $ -�� ��� J   $ (�� ��� m   $ %�� ���  u t f - 3 2� ���� m   % &�� ��� 
 u t f 3 2��  � ���� n  ( +��� o   ) +���� .0 nsutf32stringencoding NSUTF32StringEncoding� m   ( )��
�� misccura��  ��  ��  � ��� l 	 - <������ J   - <�� ��� J   - 5�� ��� m   - 0�� ���  u t f - 3 2 b e� ���� m   0 3�� ���  u t f 3 2 b e��  � ���� n  5 :��� o   6 :���� @0 nsutf32bigendianstringencoding NSUTF32BigEndianStringEncoding� m   5 6��
�� misccura��  ��  ��  � ��� l 	 < K������ J   < K�� ��� J   < D�� ��� m   < ?�� ���  u t f - 3 2 l e� ���� m   ? B�� ���  u t f 3 2 l e��  � ���� n  D I��� o   E I���� F0 !nsutf32littleendianstringencoding !NSUTF32LittleEndianStringEncoding� m   D E��
�� misccura��  ��  ��  � ��� l 	 K W������ J   K W�� ��� J   K P�� ���� m   K N�� ��� 
 a s c i i��  � ���� n  P U��� o   Q U���� .0 nsasciistringencoding NSASCIIStringEncoding� m   P Q��
�� misccura��  ��  ��  � ��� l 	 W i������ J   W i�� ��� J   W b�� ��� m   W Z�� �	 	   i s o - 2 0 2 2 - j p� 			 m   Z ]		 �		  i s o 2 0 2 2 j p	 	��	 m   ] `		 �		  c s i s o 2 0 2 2 j p��  � 	��	 n  b g			
		 o   c g���� 60 nsiso2022jpstringencoding NSISO2022JPStringEncoding	
 m   b c��
�� misccura��  ��  ��  � 			 l 	 i {	����	 J   i {		 			 J   i t		 			 m   i l		 �		  i s o - 8 8 5 9 - 1	 			 m   l o		 �		  l a t i n 1	 	��	 m   o r		 �		  i s o 8 8 5 9 - 1��  	 	��	 n  t y			 o   u y���� 60 nsisolatin1stringencoding NSISOLatin1StringEncoding	 m   t u��
�� misccura��  ��  ��  	 	 	!	  l 	 { �	"����	" J   { �	#	# 	$	%	$ J   { �	&	& 	'	(	' m   { ~	)	) �	*	*  i s o - 8 8 5 9 - 2	( 	+	,	+ m   ~ �	-	- �	.	.  l a t i n 2	, 	/��	/ m   � �	0	0 �	1	1  i s o 8 8 5 9 - 2��  	% 	2��	2 n  � �	3	4	3 o   � ����� 60 nsisolatin2stringencoding NSISOLatin2StringEncoding	4 m   � ���
�� misccura��  ��  ��  	! 	5	6	5 l 	 � �	7����	7 J   � �	8	8 	9	:	9 J   � �	;	; 	<	=	< m   � �	>	> �	?	?  e u c - j p	= 	@	A	@ m   � �	B	B �	C	C 
 u - j i s	A 	D	E	D m   � �	F	F �	G	G 
 e u c j p	E 	H��	H m   � �	I	I �	J	J  u j i s��  	: 	K��	K n  � �	L	M	L o   � ����� :0 nsjapaneseeucstringencoding NSJapaneseEUCStringEncoding	M m   � ���
�� misccura��  ��  ��  	6 	N	O	N l 	 � �	P����	P J   � �	Q	Q 	R	S	R J   � �	T	T 	U��	U m   � �	V	V �	W	W  m a c r o m a n��  	S 	X��	X n  � �	Y	Z	Y o   � ����� 80 nsmacosromanstringencoding NSMacOSRomanStringEncoding	Z m   � ���
�� misccura��  ��  ��  	O 	[	\	[ l 	 � �	]����	] J   � �	^	^ 	_	`	_ J   � �	a	a 	b	c	b m   � �	d	d �	e	e  s h i f t - j i s	c 	f	g	f m   � �	h	h �	i	i 
 s - j i s	g 	j��	j m   � �	k	k �	l	l  s j i s��  	` 	m��	m n  � �	n	o	n o   � ����� 40 nsshiftjisstringencoding NSShiftJISStringEncoding	o m   � ���
�� misccura��  ��  ��  	\ 	p	q	p l 	 � �	r����	r J   � �	s	s 	t	u	t J   � �	v	v 	w	x	w m   � �	y	y �	z	z  w i n d o w s - 1 2 5 0	x 	{	|	{ m   � �	}	} �	~	~  w i n d o w s 1 2 5 0	| 	��	 m   � �	�	� �	�	�  c p 1 2 5 0��  	u 	���	� n  � �	�	�	� o   � ����� >0 nswindowscp1250stringencoding NSWindowsCP1250StringEncoding	� m   � ���
�� misccura��  ��  ��  	q 	�	�	� l 	 � �	�����	� J   � �	�	� 	�	�	� J   � �	�	� 	�	�	� m   � �	�	� �	�	�  w i n d o w s - 1 2 5 1	� 	�	�	� m   � �	�	� �	�	�  w i n d o w s 1 2 5 1	� 	���	� m   � �	�	� �	�	�  c p 1 2 5 1��  	� 	���	� n  � �	�	�	� o   � ����� >0 nswindowscp1251stringencoding NSWindowsCP1251StringEncoding	� m   � ���
�� misccura��  ��  ��  	� 	�	�	� l 	 � �	�����	� J   � �	�	� 	�	�	� J   � �	�	� 	�	�	� m   � �	�	� �	�	�  w i n d o w s - 1 2 5 2	� 	�	�	� m   � �	�	� �	�	�  w i n d o w s 1 2 5 2	� 	���	� m   � �	�	� �	�	�  c p 1 2 5 2��  	� 	���	� n  � �	�	�	� o   � ����� >0 nswindowscp1252stringencoding NSWindowsCP1252StringEncoding	� m   � ���
�� misccura��  ��  ��  	� 	�	�	� l 	 �
	�����	� J   �
	�	� 	�	�	� J   �	�	� 	�	�	� m   � �	�	� �	�	�  w i n d o w s - 1 2 5 3	� 	�	�	� m   � �	�	� �	�	�  w i n d o w s 1 2 5 3	� 	���	� m   �	�	� �	�	�  c p 1 2 5 3��  	� 	���	� n 	�	�	� o  ���� >0 nswindowscp1253stringencoding NSWindowsCP1253StringEncoding	� m  ��
�� misccura��  ��  ��  	� 	���	� l 	
	�����	� J  
	�	� 	�	�	� J  
	�	� 	�	�	� m  
	�	� �	�	�  w i n d o w s - 1 2 5 4	� 	�	�	� m  	�	� �	�	�  w i n d o w s 1 2 5 4	� 	���	� m  	�	� �	�	�  c p 1 2 5 4��  	� 	���	� n 	�	�	� o  �� >0 nswindowscp1254stringencoding NSWindowsCP1254StringEncoding	� m  �~
�~ misccura��  ��  ��  ��  p o      �}�} 	0 _list  l 	�	�	� l     �|�{�z�|  �{  �z  	� 	��y	� i   
	�	�	� I      �x	��w�x 0 getencoding getEncoding	� 	��v	� o      �u�u 0 textencoding textEncoding�v  �w  	� Q     U	�	��t	� k    L	�	� 	�	�	� Z   	�	��s�r	� =   
	�	�	� o    �q�q 	0 _list  	� m    	�p
�p 
msng	� I    �o�n�m�o 	0 _init  �n  �m  �s  �r  	� 	��l	� P    L	�	�	�	� k    K	�	� 	�	�	� X    H	��k	�	� Z  . C	�	��j�i	� E  . 6	�	�	� n  . 2	�	�	� 4   / 2�h	�
�h 
cobj	� m   0 1�g�g 	� o   . /�f�f 0 aref aRef	� J   2 5	�	� 	��e	� o   2 3�d�d 0 textencoding textEncoding�e  	� L   9 ?	�	� n  9 >	�	�	� 4   : =�c	�
�c 
cobj	� m   ; <�b�b 	� o   9 :�a�a 0 aref aRef�j  �i  �k 0 aref aRef	� n   "	�	�	� o     "�`�` 	0 _list  	�  f     	� 
 �_
  L   I K

 m   I J�^
�^ 
msng�_  	� �]

�] consdiac
 �\

�\ conshyph
 �[

�[ conspunc
 �Z�Y
�Z conswhit�Y  	� �X

�X conscase
 �W�V
�W consnume�V  �l  	� R      �U�T�S
�U .ascrerr ****      � ****�T  �S  �t  �y  ^ g a used by `send HTTP request` to automatically encode/decode text-based request/response body data   _ �

 �   u s e d   b y   ` s e n d   H T T P   r e q u e s t `   t o   a u t o m a t i c a l l y   e n c o d e / d e c o d e   t e x t - b a s e d   r e q u e s t / r e s p o n s e   b o d y   d a t a[ 


 l     �R�Q�P�R  �Q  �P  
 
	


	 l     �O�N�M�O  �N  �M  

 


 i  � �


 I      �L
�K�L 0 _parsecharset _parseCharset
 
�J
 o      �I�I "0 asoccontenttype asocContentType�J  �K  
 k     :

 


 l    



 r     


 n    



 I    
�H
�G�H Z0 +regularexpressionwithpattern_options_error_ +regularExpressionWithPattern_options_error_
 


 m    

 �

 V ( ? i ) ; \ s * c h a r s e t \ s * = \ s * ( " ? ) ( . + ? ) \ 1 \ s * ( ? : ; | $ )
 
 
!
  m    �F�F  
! 
"�E
" l   
#�D�C
# m    �B
�B 
msng�D  �C  �E  �G  
 n    
$
%
$ o    �A�A *0 nsregularexpression NSRegularExpression
% m     �@
�@ misccura
 o      �?�? 0 asocpattern asocPattern
 � � sloppy non-RFC1341 pattern not appropriate for general parameter matching, but adequate here as the value will be rejected anyway unless it matches one of the encoding names defined above   
 �
&
&x   s l o p p y   n o n - R F C 1 3 4 1   p a t t e r n   n o t   a p p r o p r i a t e   f o r   g e n e r a l   p a r a m e t e r   m a t c h i n g ,   b u t   a d e q u a t e   h e r e   a s   t h e   v a l u e   w i l l   b e   r e j e c t e d   a n y w a y   u n l e s s   i t   m a t c h e s   o n e   o f   t h e   e n c o d i n g   n a m e s   d e f i n e d   a b o v e
 
'
(
' r    
)
*
) n   
+
,
+ I    �>
-�=�> F0 !firstmatchinstring_options_range_ !firstMatchInString_options_range_
- 
.
/
. o    �<�< "0 asoccontenttype asocContentType
/ 
0
1
0 m    �;�;  
1 
2�:
2 J    
3
3 
4
5
4 m    �9�9  
5 
6�8
6 n   
7
8
7 I    �7�6�5�7 
0 length  �6  �5  
8 o    �4�4 "0 asoccontenttype asocContentType�8  �:  �=  
, o    �3�3 0 asocpattern asocPattern
* o      �2�2 0 	asocmatch 	asocMatch
( 
9
:
9 Z   +
;
<�1�0
; =   "
=
>
= o     �/�/ 0 	asocmatch 	asocMatch
> m     !�.
�. 
msng
< L   % '
?
? m   % &�-
�- 
msng�1  �0  
: 
@�,
@ L   , :
A
A c   , 9
B
C
B l  , 7
D�+�*
D n  , 7
E
F
E I   - 7�)
G�(�) *0 substringwithrange_ substringWithRange_
G 
H�'
H l  - 3
I�&�%
I n  - 3
J
K
J I   . 3�$
L�#�$ 0 rangeatindex_ rangeAtIndex_
L 
M�"
M m   . /�!�! �"  �#  
K o   - .� �  0 	asocmatch 	asocMatch�&  �%  �'  �(  
F o   , -�� "0 asoccontenttype asocContentType�+  �*  
C m   7 8�
� 
ctxt�,  
 
N
O
N l     ����  �  �  
O 
P
Q
P l     ����  �  �  
Q 
R
S
R i  � �
T
U
T I      �
V�� $0 _makehttprequest _makeHTTPRequest
V 
W
X
W o      �� 0 theurl theURL
X 
Y
Z
Y o      �� 0 
httpmethod 
httpMethod
Z 
[
\
[ o      ��  0 requestheaders requestHeaders
\ 
]
^
] o      �� 0 requestbody requestBody
^ 
_�
_ o      �� $0 timeoutinseconds timeoutInSeconds�  �  
U P    }
`
a
b
` k   |
c
c 
d
e
d l   �
f
g�  
f   build HTTP request   
g �
h
h &   b u i l d   H T T P   r e q u e s t
e 
i
j
i r    
k
l
k n   
m
n
m I    �
o�� "0 requestwithurl_ requestWithURL_
o 
p�
p l   
q��

q n   
r
s
r I    �	
t��	 $0 asnsurlparameter asNSURLParameter
t 
u
v
u o    �� 0 theurl theURL
v 
w�
w m    
x
x �
y
y  t o�  �  
s o    �� 0 _support  �  �
  �  �  
n n   
z
{
z o    �� *0 nsmutableurlrequest NSMutableURLRequest
{ m    �
� misccura
l o      �� 0 httprequest httpRequest
j 
|
}
| l   '
~

�
~ r    '
�
�
� n   %
�
�
� I    %�
�� � "0 astextparameter asTextParameter
� 
�
�
� o     ���� 0 
httpmethod 
httpMethod
� 
���
� m     !
�
� �
�
�  m e t h o d��  �   
� o    ���� 0 _support  
� o      ���� 0 
httpmethod 
httpMethod
 O I TO DO: what if any checks are needed here (e.g. non-empty/invalid chars)   
� �
�
� �   T O   D O :   w h a t   i f   a n y   c h e c k s   a r e   n e e d e d   h e r e   ( e . g .   n o n - e m p t y / i n v a l i d   c h a r s )
} 
�
�
� n  ( .
�
�
� I   ) .��
�����  0 sethttpmethod_ setHTTPMethod_
� 
���
� o   ) *���� 0 
httpmethod 
httpMethod��  ��  
� o   ( )���� 0 httprequest httpRequest
� 
�
�
� l  / ?
�
�
�
� Z  / ?
�
�����
� >  / 2
�
�
� o   / 0���� $0 timeoutinseconds timeoutInSeconds
� m   0 1��
�� 
msng
� n  5 ;
�
�
� I   6 ;��
����� *0 settimeoutinterval_ setTimeoutInterval_
� 
���
� o   6 7���� $0 timeoutinseconds timeoutInSeconds��  ��  
� o   5 6���� 0 httprequest httpRequest��  ��  
� � � If during a connection attempt the request remains idle for longer than the timeout interval, the request is considered to have timed out.   
� �
�
�   I f   d u r i n g   a   c o n n e c t i o n   a t t e m p t   t h e   r e q u e s t   r e m a i n s   i d l e   f o r   l o n g e r   t h a n   t h e   t i m e o u t   i n t e r v a l ,   t h e   r e q u e s t   i s   c o n s i d e r e d   t o   h a v e   t i m e d   o u t .
� 
�
�
� l  @ @��
�
���  
� $  add request headers, if given   
� �
�
� <   a d d   r e q u e s t   h e a d e r s ,   i f   g i v e n
� 
�
�
� Z   @%
�
�����
� >  @ C
�
�
� o   @ A����  0 requestheaders requestHeaders
� m   A B��
�� 
msng
� X   F!
���
�
� k   `
�
� 
�
�
� Q   ` �
�
�
�
� k   c �
�
� 
�
�
� r   c n
�
�
� c   c l
�
�
� n  c h
�
�
� 1   d h��
�� 
pcnt
� o   c d���� 0 aref aRef
� m   h k��
�� 
reco
� o      ���� 0 headerrecord headerRecord
� 
�
�
� l  o �
�
�
�
� Z  o �
�
�����
� >   o z
�
�
� l  o x
�����
� I  o x��
�
�
�� .corecnte****       ****
� o   o p���� 0 headerrecord headerRecord
� ��
���
�� 
kocl
� m   q t��
�� 
ctxt��  ��  ��  
� m   x y���� 
� R   } �����
�
�� .ascrerr ****      � ****��  
� ��
���
�� 
errn
� m   � ������Y��  ��  ��  
� note: requiring text values here avoids any risk of numbers being accidentally coerced to inappropriate localized representations (e.g. "1,0" instead of "1.0"); user should use Number library's `format number` command to convert numbers to non-localized format first   
� �
�
�   n o t e :   r e q u i r i n g   t e x t   v a l u e s   h e r e   a v o i d s   a n y   r i s k   o f   n u m b e r s   b e i n g   a c c i d e n t a l l y   c o e r c e d   t o   i n a p p r o p r i a t e   l o c a l i z e d   r e p r e s e n t a t i o n s   ( e . g .   " 1 , 0 "   i n s t e a d   o f   " 1 . 0 " ) ;   u s e r   s h o u l d   u s e   N u m b e r   l i b r a r y ' s   ` f o r m a t   n u m b e r `   c o m m a n d   t o   c o n v e r t   n u m b e r s   t o   n o n - l o c a l i z e d   f o r m a t   f i r s t
� 
���
� r   � �
�
�
� J   � �
�
� 
�
�
� n  � �
�
�
� o   � ����� 0 
headername 
headerName
� o   � ����� 0 headerrecord headerRecord
� 
���
� n  � �
�
�
� o   � ����� 0 headervalue headerValue
� o   � ����� 0 headerrecord headerRecord��  
� J      
�
� 
�
�
� o      ���� 0 
headername 
headerName
� 
���
� o      ���� 0 headervalue headerValue��  ��  
� R      ��
�
�
�� .ascrerr ****      � ****
� o      ���� 0 etext eText
� ��
�
�
�� 
errn
� o      ���� 0 enum eNum
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
0 eto eTo��  
� k   � �
�
� 
�
�
� Z  � �
�
�����
� H   � �
�
� E  � �
�
�
� J   � �
�
� 
�
�
� m   � ������\
� 
�
�
� m   � ������Y
� 
���
� m   � ������@��  
� J   � �
�
� 
���
� o   � ����� 0 enum eNum��  
� R   � ���
�
�
�� .ascrerr ****      � ****
� o   � ����� 0 etext eText
� ��
�
�
�� 
errn
� o   � ����� 0 enum eNum
� ��
�
�
�� 
erob
� o   � ����� 0 efrom eFrom
� ��
���
�� 
errt
� o   � ����� 
0 eto eTo��  ��  ��  
� 
���
� n  � �
�
�
� I   � ���
����� .0 throwinvalidparameter throwInvalidParameter
� 
�
�
� o   � ����� 0 aref aRef
� 
� 
� m   � � �  h e a d e r s   m   � ���
�� 
list �� m   � � � P N o t   a   l i s t   o f   v a l i d   H T T P   h e a d e r   r e c o r d s .��  ��  
� o   � ����� 0 _support  ��  
� 	 Z   �
����
 E  � � o   � ����� "0 _excludeheaders _excludeHeaders o   � ����� 0 
headername 
headerName n  � I   ������� .0 throwinvalidparameter throwInvalidParameter  o   � ����� 0 aref aRef  m   � �  h e a d e r s  m  ��
�� 
list �� b  
 m   � � T h e   f o l l o w i n g   h e a d e r   i s   n o t   a l l o w e d   i n   t h e   h e a d e r s   l i s t   a s   i t   i s   a l r e a d y   s e t   a u t o m a t i c a l l y :   o  	���� 0 
headername 
headerName��  ��   o   � ����� 0 _support  ��  ��  	 �� l  ! l "����" n #$# I  ��%���� <0 setvalue_forhttpheaderfield_ setValue_forHTTPHeaderField_% &'& o  ���� 0 headervalue headerValue' (��( o  ���� 0 
headername 
headerName��  ��  $ o  ���� 0 httprequest httpRequest��  ��    ` Z TO DO: does NSHTTPRequest sanitize these inputs; if not, how should they be treated here?   ! �)) �   T O   D O :   d o e s   N S H T T P R e q u e s t   s a n i t i z e   t h e s e   i n p u t s ;   i f   n o t ,   h o w   s h o u l d   t h e y   b e   t r e a t e d   h e r e ?��  �� 0 aref aRef
� n  I T*+* I   N T��,���� "0 aslistparameter asListParameter, -.- o   N O����  0 requestheaders requestHeaders. /��/ m   O P00 �11  h e a d e r s��  ��  + o   I N���� 0 _support  ��  ��  
� 232 l &&��45��  4   add request body   5 �66 "   a d d   r e q u e s t   b o d y3 787 Z  &y9:����9 > &);<; o  &'���� 0 requestbody requestBody< m  '(��
�� 
msng: l ,u=>?= Z  ,u@ABC@ =  ,9DED l ,7F����F I ,7��GH
�� .corecnte****       ****G J  ,/II J��J o  ,-���� 0 requestbody requestBody��  H ��K��
�� 
koclK m  03��
�� 
ctxt��  ��  ��  E m  78���� A l <LMNL k  <OO PQP l <<��RS��  R x r if user supplies "Content-Type" header, parse its `charset` param if it has one to determine text encoding to use   S �TT �   i f   u s e r   s u p p l i e s   " C o n t e n t - T y p e "   h e a d e r ,   p a r s e   i t s   ` c h a r s e t `   p a r a m   i f   i t   h a s   o n e   t o   d e t e r m i n e   t e x t   e n c o d i n g   t o   u s eQ UVU r  <FWXW n <DYZY I  =D��[���� 40 valueforhttpheaderfield_ valueForHTTPHeaderField_[ \��\ m  =@]] �^^  C o n t e n t - T y p e��  ��  Z o  <=�� 0 httprequest httpRequestX o      �~�~ 0 contenttype contentTypeV _`_ Z  G�ab�}ca = GJded o  GH�|�| 0 contenttype contentTypee m  HI�{
�{ 
msngb l M^fghf k  M^ii jkj n MXlml I  NX�zn�y�z <0 setvalue_forhttpheaderfield_ setValue_forHTTPHeaderField_n opo m  NQqq �rr 0 t e x t / p l a i n ; c h a r s e t = u t f - 8p s�xs m  QTtt �uu  C o n t e n t - T y p e�x  �y  m o  MN�w�w 0 httprequest httpRequestk v�vv r  Y^wxw o  YZ�u�u ,0 nsutf8stringencoding NSUTF8StringEncodingx o      �t�t *0 requestbodyencoding requestBodyEncoding�v  g 0 * encode text-based body as UTF8 by default   h �yy T   e n c o d e   t e x t - b a s e d   b o d y   a s   U T F 8   b y   d e f a u l t�}  c l a�z{|z k  a�}} ~~ r  at��� I  ap�s��r�s 0 _parsecharset _parseCharset� ��q� n bl��� I  gl�p��o�p 0 
asnsstring 
asNSString� ��n� o  gh�m�m 0 contenttype contentType�n  �o  � o  bg�l�l 0 _support  �q  �r  � o      �k�k 0 charsetname charsetName ��j� Z  u����i�� = uz��� o  ux�h�h 0 charsetname charsetName� m  xy�g
�g 
msng� l }����� k  }��� ��� n }���� I  ~��f��e�f <0 setvalue_forhttpheaderfield_ setValue_forHTTPHeaderField_� ��� l ~���d�c� b  ~���� o  ~�b�b 0 contenttype contentType� m  ��� ���  ; c h a r s e t = u t f - 8�d  �c  � ��a� m  ���� ���  C o n t e n t - T y p e�a  �e  � o  }~�`�` 0 httprequest httpRequest� ��_� r  ����� o  ���^�^ ,0 nsutf8stringencoding NSUTF8StringEncoding� o      �]�] *0 requestbodyencoding requestBodyEncoding�_  � Q K if Content-Type doesn't include charset parameter then use UTF8 by default   � ��� �   i f   C o n t e n t - T y p e   d o e s n ' t   i n c l u d e   c h a r s e t   p a r a m e t e r   t h e n   u s e   U T F 8   b y   d e f a u l t�i  � l ������ k  ���� ��� r  ����� n ����� I  ���\��[�\ 0 getencoding getEncoding� ��Z� o  ���Y�Y 0 charsetname charsetName�Z  �[  � o  ���X�X (0 _nsstringencodings _NSStringEncodings� o      �W�W *0 requestbodyencoding requestBodyEncoding� ��V� Z  �����U�T� = ����� o  ���S�S *0 requestbodyencoding requestBodyEncoding� m  ���R
�R 
msng� n ����� I  ���Q��P�Q .0 throwinvalidparameter throwInvalidParameter� ��� o  ���O�O  0 requestheaders requestHeaders� ��� m  ���� ���  h e a d e r s� ��� m  ���N
�N 
list� ��M� m  ���� ���n T h e   C o n t e n t - T y p e   h e a d e r   s p e c i f i e s   a   c h a r s e t   t h a t   c a n n o t   b e   a u t o m a t i c a l l y   e n c o d e d   b y   t h i s   h a n d l e r   ( e . g .   u s e   a   d i f f e r e n t   c h a r s e t   o r   s u p p l y   t h e   r e q u e s t   b o d y   a s   a n   N S D a t a   o b j e c t   i n s t e a d ) .�M  �P  � o  ���L�L 0 _support  �U  �T  �V  � � � automatically encode the body text using the specified charset (assuming it's one directly recognized by NSString's dataUsingEncoding: method)   � ���   a u t o m a t i c a l l y   e n c o d e   t h e   b o d y   t e x t   u s i n g   t h e   s p e c i f i e d   c h a r s e t   ( a s s u m i n g   i t ' s   o n e   d i r e c t l y   r e c o g n i z e d   b y   N S S t r i n g ' s   d a t a U s i n g E n c o d i n g :   m e t h o d )�j  { V P user has specified Content-Type for body (e.g. "application/json;charset=utf8")   | ��� �   u s e r   h a s   s p e c i f i e d   C o n t e n t - T y p e   f o r   b o d y   ( e . g .   " a p p l i c a t i o n / j s o n ; c h a r s e t = u t f 8 " )` ��� r  ����� n ����� I  ���K��J�K (0 datausingencoding_ dataUsingEncoding_� ��I� o  ���H�H *0 requestbodyencoding requestBodyEncoding�I  �J  � n ����� I  ���G��F�G 0 
asnsstring 
asNSString� ��E� o  ���D�D 0 requestbody requestBody�E  �F  � o  ���C�C 0 _support  � o      �B�B 0 bodydata bodyData� ��� Z  ����A�@� = ����� o  ���?�? 0 bodydata bodyData� m  ���>
�> 
msng� n � ��� I  � �=��<�= .0 throwinvalidparameter throwInvalidParameter� ��� o  ���;�;  0 requestheaders requestHeaders� ��� m  ���� ���  b o d y� ��� J  ���� ��� m  ���:
�: 
ctxt� ��9� m  ���8
�8 
ocid�9  � ��7� b  ����� m  ���� ��� � C a n  t   e n c o d e   t h e   g i v e n   t e x t   u s i n g   t h e   c h a r s e t   s p e c i f i e d   b y   t h e   C o n t e n t - T y p e   h e a d e r :  � o  ���6�6 0 contenttype contentType�7  �<  � o  ���5�5 0 _support  �A  �@  � ��4� n ��� I  �3��2�3 0 sethttpbody_ setHTTPBody_� ��1� o  	�0�0 0 bodydata bodyData�1  �2  � o  �/�/ 0 httprequest httpRequest�4  M �  given a text value to use as the request body, encode it using rgw xhEAWR specified by the user-supplied Content-Type, if any,   N ��� �   g i v e n   a   t e x t   v a l u e   t o   u s e   a s   t h e   r e q u e s t   b o d y ,   e n c o d e   i t   u s i n g   r g w   x h E A W R   s p e c i f i e d   b y   t h e   u s e r - s u p p l i e d   C o n t e n t - T y p e ,   i f   a n y ,B ��� F  2��� n ��� I  �.��-�. &0 checktypeforvalue checkTypeForValue� ��� o  �,�, 0 requestbody requestBody� ��+� m  �*
�* 
ocid�+  �-  � o  �)�) 0 _support  � l  .��(�'� n  .��� I  !.�&��%�& &0 isinstanceoftype_ isInstanceOfType_�  �$  l !*�#�" n !* I  &*�!� ��! 	0 class  �   �   n !& o  "&�� 0 nsdata NSData m  !"�
� misccura�#  �"  �$  �%  � o   !�� 0 requestbody requestBody�(  �'  � � k  5X 	 l 55�
�  
 � � also accept NSData, allowing users to do their own encoding/decoding; users should supply appropriate Content-Type header themselves    �
   a l s o   a c c e p t   N S D a t a ,   a l l o w i n g   u s e r s   t o   d o   t h e i r   o w n   e n c o d i n g / d e c o d i n g ;   u s e r s   s h o u l d   s u p p l y   a p p r o p r i a t e   C o n t e n t - T y p e   h e a d e r   t h e m s e l v e s	  n 5; I  6;��� 0 sethttpbody_ setHTTPBody_ � o  67�� 0 requestbody requestBody�  �   o  56�� 0 httprequest httpRequest � Z  <X�� n <F I  =F��� 40 valueforhttpheaderfield_ valueForHTTPHeaderField_ � l =B�� = =B m  =@ �  C o n t e n t - T y p e m  @A�
� 
msng�  �  �  �   o  <=�� 0 httprequest httpRequest l IT ! n IT"#" I  JT�
$�	�
 <0 setvalue_forhttpheaderfield_ setValue_forHTTPHeaderField_$ %&% m  JM'' �(( 0 a p p l i c a t i o n / o c t e t - s t r e a m& )�) m  MP** �++  C o n t e n t - T y p e�  �	  # o  IJ�� 0 httprequest httpRequest    arbitrary binary data   ! �,, ,   a r b i t r a r y   b i n a r y   d a t a�  �  �  �  C n [u-.- I  `u�/�� .0 throwinvalidparameter throwInvalidParameter/ 010 o  `a�� 0 requestbody requestBody1 232 m  ad44 �55  b o d y3 676 J  dl88 9:9 m  dg�
� 
ctxt: ;�; m  gj�
� 
ocid�  7 <� < m  lo== �>> 8 N o t   a   t e x t   o r   N S D a t a   o b j e c t .�   �  . o  [`���� 0 _support  > V P requestBody may be supplied as text or NSData -- TO DO: what about file object?   ? �?? �   r e q u e s t B o d y   m a y   b e   s u p p l i e d   a s   t e x t   o r   N S D a t a   - -   T O   D O :   w h a t   a b o u t   f i l e   o b j e c t ?��  ��  8 @��@ L  z|AA o  z{���� 0 httprequest httpRequest��  
a ��B
�� consdiacB ��C
�� conshyphC ��D
�� conspuncD ����
�� conswhit��  
b ��E
�� conscaseE ����
�� consnume��  
S FGF l     ��������  ��  ��  G HIH l     ��������  ��  ��  I JKJ i  � �LML I      ��N���� *0 _unpackhttpresponse _unpackHTTPResponseN OPO o      ���� 0 httpresponse httpResponseP QRQ o      ���� $0 responsebodytype responseBodyTypeR S��S o      ���� $0 responsebodydata responseBodyData��  ��  M k     �TT UVU r     WXW J     ����  X o      ���� 0 headerfields headerFieldsV YZY r    [\[ n   
]^] I    
�������� "0 allheaderfields allHeaderFields��  ��  ^ o    ���� 0 httpresponse httpResponse\ o      ���� $0 asocheaderfields asocHeaderFieldsZ _`_ r    aba n   cdc I    �������� 0 allkeys allKeys��  ��  d o    ���� $0 asocheaderfields asocHeaderFieldsb o      ���� 0 
headerkeys 
headerKeys` efe Y    Eg��hi��g k   % @jj klk r   % -mnm l  % +o����o n  % +pqp I   & +��r����  0 objectatindex_ objectAtIndex_r s��s o   & '���� 0 i  ��  ��  q o   % &���� 0 
headerkeys 
headerKeys��  ��  n o      ���� 0 asockey asocKeyl t��t r   . @uvu K   . =ww ��xy�� 0 
headername 
headerNamex c   / 2z{z o   / 0���� 0 asockey asocKey{ m   0 1��
�� 
ctxty ��|���� 0 headervalue headerValue| c   3 ;}~} l  3 9���� n  3 9��� I   4 9������� 0 objectforkey_ objectForKey_� ���� o   4 5���� 0 asockey asocKey��  ��  � o   3 4���� $0 asocheaderfields asocHeaderFields��  ��  ~ m   9 :��
�� 
****��  v n      ���  ;   > ?� o   = >���� 0 headerfields headerFields��  �� 0 i  h m    ����  i \     ��� l   ������ n   ��� I    �������� 	0 count  ��  ��  � o    ���� $0 asocheaderfields asocHeaderFields��  ��  � m    ���� ��  f ��� Z   F ������ =  F I��� o   F G���� $0 responsebodytype responseBodyType� m   G H��
�� 
ctxt� k   L ��� ��� r   L O��� m   L M��
�� 
msng� o      ���� ,0 responsebodyencoding responseBodyEncoding� ��� r   P X��� n  P V��� I   Q V������� 0 objectforkey_ objectForKey_� ���� m   Q R�� ���  C o n t e n t - T y p e��  ��  � o   P Q���� $0 asocheaderfields asocHeaderFields� o      ���� "0 asoccontenttype asocContentType� ��� Z  Y t������� >  Y \��� o   Y Z���� "0 asoccontenttype asocContentType� m   Z [��
�� 
msng� r   _ p��� n  _ n��� I   d n������� 0 getencoding getEncoding� ���� I   d j������� 0 _parsecharset _parseCharset� ���� o   e f���� "0 asoccontenttype asocContentType��  ��  ��  ��  � o   _ d���� (0 _nsstringencodings _NSStringEncodings� o      ���� ,0 responsebodyencoding responseBodyEncoding��  ��  � ��� Z   u �������� =  u x��� o   u v���� ,0 responsebodyencoding responseBodyEncoding� m   v w��
�� 
msng� R   { �����
�� .ascrerr ****      � ****� m    ��� ��� � C a n ' t   a u t o m a t i c a l l y   d e c o d e   H T T P   r e s p o n s e   a s   t e x t   a s   i t   d i d n ' t   s p e c i f y   a   C o n t e n t - T y p e   w i t h   a   s u p p o r t e d   c h a r s e t .� �����
�� 
errn� m   } ~�����\��  ��  ��  � ���� r   � ���� c   � ���� l  � ������� n  � ���� I   � �������� 00 initwithdata_encoding_ initWithData_encoding_� ��� o   � ����� $0 responsebodydata responseBodyData� ���� o   � ����� ,0 responsebodyencoding responseBodyEncoding��  ��  � n  � ���� I   � ��������� 	0 alloc  ��  ��  � n  � ���� o   � ����� 0 nsstring NSString� m   � ���
�� misccura��  ��  � m   � ���
�� 
ctxt� o      ���� 0 responsebody responseBody��  � ��� =  � ���� o   � ����� $0 responsebodytype responseBodyType� m   � ���
�� 
rdat� ��� l  � ����� r   � ���� n  � ���� I   � ��������� 0 copy  ��  ��  � o   � ����� $0 responsebodydata responseBodyData� o      ���� 0 responsebody responseBody�   return NSData   � ���    r e t u r n   N S D a t a� ��� =  � ���� o   � ����� $0 responsebodytype responseBodyType� m   � ���
�� 
msng� ���� r   � ���� m   � ���
�� 
msng� o      ���� 0 responsebody responseBody��  � n  � ���� I   � �������� >0 throwinvalidconstantparameter throwInvalidConstantParameter� ��� o   � ����� $0 responsebodytype responseBodyType� ��� m   � ��� ���  r e t u r n i n g�  ��  � o   � ��~�~ 0 _support  � ��}� L   � ��� K   � ��� �|���| 0 
statuscode 
statusCode� n  � ���� I   � ��{�z�y�{ 0 
statuscode 
statusCode�z  �y  � o   � ��x�x 0 httpresponse httpResponse� �w���w "0 responseheaders responseHeaders� o   � ��v�v 0 headerfields headerFields� �u��t�u 0 responsebody responseBody� o   � ��s�s 0 responsebody responseBody�t  �}  K ��� l     �r�q�p�r  �q  �p  � ��� l     �o�n�m�o  �n  �m  � ��� l     �l���l  �  -----   � ��� 
 - - - - -� ��� l     �k�j�i�k  �j  �i  � ��� i  � �� � I     �h�g
�h .Web:ReqHnull��� ��� null�g   �f
�f 
Dest o      �e�e 0 theurl theURL �d
�d 
Meth |�c�b�a�c  �b   o      �`�` 0 
httpmethod 
httpMethod�a   l     �_�^ m      		 �

  G E T�_  �^   �]
�] 
Head |�\�[�Z�\  �[   o      �Y�Y  0 requestheaders requestHeaders�Z   J      �X�X   �W
�W 
Body |�V�U�T�V  �U   o      �S�S 0 requestbody requestBody�T   l     �R�Q m      �P
�P 
msng�R  �Q   �O
�O 
TimO |�N�M�L�N  �M   o      �K�K $0 timeoutinseconds timeoutInSeconds�L   l     �J�I m      �H
�H 
msng�J  �I   �G�F
�G 
Type |�E�D�C�E  �D   o      �B�B $0 responsebodytype responseBodyType�C   l     �A�@ m      �?
�? 
ctxt�A  �@  �F    Q    / k      !"! Z    #$�>�=# >   %&% o    �<�< $0 timeoutinseconds timeoutInSeconds& m    �;
�; 
msng$ r   	 '(' n  	 )*) I    �:+�9�: (0 asintegerparameter asIntegerParameter+ ,-, o    �8�8 $0 timeoutinseconds timeoutInSeconds- .�7. m    // �00  t i m e o u t�7  �9  * o   	 �6�6 0 _support  ( o      �5�5 $0 timeoutinseconds timeoutInSeconds�>  �=  " 121 r    '343 I    %�45�3�4 $0 _makehttprequest _makeHTTPRequest5 676 o    �2�2 0 theurl theURL7 898 o    �1�1 0 
httpmethod 
httpMethod9 :;: o    �0�0  0 requestheaders requestHeaders; <=< o     �/�/ 0 requestbody requestBody= >�.> o     !�-�- $0 timeoutinseconds timeoutInSeconds�.  �3  4 o      �,�, 0 httprequest httpRequest2 ?@? r   ( 1ABA n  ( /CDC I   + /�+�*�)�+ >0 ephemeralsessionconfiguration ephemeralSessionConfiguration�*  �)  D n  ( +EFE o   ) +�(�( 60 nsurlsessionconfiguration NSURLSessionConfigurationF m   ( )�'
�' misccuraB o      �&�& 0 sessionconfig sessionConfig@ GHG l  2 BIJKI Z  2 BLM�%�$L >  2 5NON o   2 3�#�# $0 timeoutinseconds timeoutInSecondsO m   3 4�"
�" 
msngM n  8 >PQP I   9 >�!R� �! >0 settimeoutintervalforrequest_ setTimeoutIntervalForRequest_R S�S o   9 :�� $0 timeoutinseconds timeoutInSeconds�  �   Q o   8 9�� 0 sessionconfig sessionConfig�%  �$  J g a controls how long (in seconds) a task should wait for additional data to arrive before giving up   K �TT �   c o n t r o l s   h o w   l o n g   ( i n   s e c o n d s )   a   t a s k   s h o u l d   w a i t   f o r   a d d i t i o n a l   d a t a   t o   a r r i v e   b e f o r e   g i v i n g   u pH UVU Z   C xWX�YW =  C FZ[Z o   C D�� $0 responsebodytype responseBodyType[ m   D E�
� 
msngX k   I W\\ ]^] r   I S_`_ n  I Qaba I   L Q�c�� 60 sessionwithconfiguration_ sessionWithConfiguration_c d�d o   L M�� 0 sessionconfig sessionConfig�  �  b n  I Lefe o   J L�� 0 nsurlsession NSURLSessionf m   I J�
� misccura` o      �� 0 asocsession asocSession^ g�g r   T Whih m   T U�
� 
msngi o      �� $0 responsebodydata responseBodyData�  �  Y k   Z xjj klk r   Z cmnm n  Z aopo I   ] a���� 0 data  �  �  p n  Z ]qrq o   [ ]�� 0 nsmutabledata NSMutableDatar m   Z [�
� misccuran o      �
�
 $0 responsebodydata responseBodyDatal sts h   d k�	u�	 *0 sessiontaskdelegate sessionTaskDelegateu i     vwv I      �x�� J0 #urlsession_datatask_didreceivedata_ #URLSession_dataTask_didReceiveData_x yzy o      �� 0 asocsession asocSessionz {|{ o      �� 0 asoctask asocTask| }�} o      �� 0 asocdata asocData�  �  w n    
~~ I    
���� 0 appenddata_ appendData_� �� � o    ���� 0 asocdata asocData�   �   o     ���� $0 responsebodydata responseBodyDatat ���� r   l x��� n  l v��� I   o v������� d0 0sessionwithconfiguration_delegate_delegatequeue_ 0sessionWithConfiguration_delegate_delegateQueue_� ��� o   o p���� 0 sessionconfig sessionConfig� ��� o   p q���� *0 sessiontaskdelegate sessionTaskDelegate� ���� l  q r������ m   q r��
�� 
msng��  ��  ��  ��  � n  l o��� o   m o���� 0 nsurlsession NSURLSession� m   l m��
�� misccura� o      ���� 0 asocsession asocSession��  V ��� r   y ���� n  y ��� I   z ������� ,0 datataskwithrequest_ dataTaskWithRequest_� ���� o   z {���� 0 httprequest httpRequest��  ��  � o   y z���� 0 asocsession asocSession� o      ���� 0 asoctask asocTask� ��� n  � ���� I   � ��������� 
0 resume  ��  ��  � o   � ����� 0 asoctask asocTask� ��� l  � �������  � � � block until completed/failed; TO DO: can user cancel during this loop? (if so, does anything need to be done with error -128? e.g. catch, call cancel, then rethrow)   � ���J   b l o c k   u n t i l   c o m p l e t e d / f a i l e d ;   T O   D O :   c a n   u s e r   c a n c e l   d u r i n g   t h i s   l o o p ?   ( i f   s o ,   d o e s   a n y t h i n g   n e e d   t o   b e   d o n e   w i t h   e r r o r   - 1 2 8 ?   e . g .   c a t c h ,   c a l l   c a n c e l ,   t h e n   r e t h r o w )� ��� V   � ���� l  � ����� n  � ���� I   � �������� .0 sleepfortimeinterval_ sleepForTimeInterval_� ���� m   � ��� ?���������  ��  � n  � ���� o   � ����� 0 nsthread NSThread� m   � ���
�� misccura�   sleep for 0.1sec   � ��� "   s l e e p   f o r   0 . 1 s e c� =  � ���� n  � ���� I   � ��������� 	0 state  ��  ��  � o   � ����� 0 asoctask asocTask� n  � ���� o   � ����� <0 nsurlsessiontaskstaterunning NSURLSessionTaskStateRunning� m   � ���
�� misccura� ��� Z   � �������� =  � ���� n  � ���� I   � ��������� 	0 state  ��  ��  � o   � ����� 0 asoctask asocTask� n  � ���� o   � ����� @0 nsurlsessiontaskstatesuspended NSURLSessionTaskStateSuspended� m   � ���
�� misccura� l  � ����� n  � ���� I   � ��������� 
0 cancel  ��  ��  � o   � ����� 0 asoctask asocTask� D > sanity check (shouldn't be possible for task to be suspended)   � ��� |   s a n i t y   c h e c k   ( s h o u l d n ' t   b e   p o s s i b l e   f o r   t a s k   t o   b e   s u s p e n d e d )��  ��  � ��� Z   � �������� =  � ���� n  � ���� I   � ��������� 	0 state  ��  ��  � o   � ����� 0 asoctask asocTask� n  � ���� o   � ����� @0 nsurlsessiontaskstatecanceling NSURLSessionTaskStateCanceling� m   � ���
�� misccura� l  � ����� R   � ������
�� .ascrerr ****      � ****��  � �����
�� 
errn� m   � ���������  � * $ TO DO: does Cmd-period cancel task?   � ��� H   T O   D O :   d o e s   C m d - p e r i o d   c a n c e l   t a s k ?��  ��  � ��� r   � ���� n  � ���� I   � ��������� 	0 error  ��  ��  � o   � ����� 0 asoctask asocTask� o      ���� 0 	taskerror 	taskError� ��� Z   �������� >  � ���� o   � ����� 0 	taskerror 	taskError� m   � ���
�� 
msng� R   �����
�� .ascrerr ****      � ****� l  ������� c   ���� n  ���� I   ��������� ,0 localizeddescription localizedDescription��  ��  � o   � ����� 0 	taskerror 	taskError� m  ��
�� 
ctxt��  ��  � ����
�� 
errn� n  � ���� I   � ��������� 0 code  ��  ��  � o   � ����� 0 	taskerror 	taskError� �����
�� 
erob� o   � ����� 0 theurl theURL��  ��  ��  � ���� L  �� I  ������� *0 _unpackhttpresponse _unpackHTTPResponse� ��� n ��� I  �������� 0 response  ��  ��  � o  ���� 0 asoctask asocTask� ��� o  ���� $0 responsebodytype responseBodyType� ���� o  ���� $0 responsebodydata responseBodyData��  ��  ��   R      ����
�� .ascrerr ****      � ****� o      ���� 0 etext eText� ����
�� 
errn� o      ���� 0 enumber eNumber� ����
�� 
erob� o      ���� 0 efrom eFrom� �����
�� 
errt� o      ���� 
0 eto eTo��   I  !/������� 
0 _error  �    m  "% � " s e n d   H T T P   r e q u e s t  o  %&���� 0 etext eText  o  &'���� 0 enumber eNumber 	 o  '(���� 0 efrom eFrom	 
��
 o  (+���� 
0 eto eTo��  ��  �  l     ��������  ��  ��    l     ��������  ��  ��    l     ��������  ��  ��    l     ��������  ��  ��    l     ��������  ��  ��    i  � � I     ���
�� .Web:DStCnull���     long o      �~�~ 0 
statuscode 
statusCode�   Q     . k      r     !  n   "#" I    �}$�|�} (0 asintegerparameter asIntegerParameter$ %&% o    	�{�{ 0 
statuscode 
statusCode& '�z' m   	 
(( �))  �z  �|  # o    �y�y 0 _support  ! o      �x�x 0 
statuscode 
statusCode *�w* L    ++ c    ,-, l   .�v�u. n   /0/ I    �t1�s�t >0 localizedstringforstatuscode_ localizedStringForStatusCode_1 2�r2 o    �q�q 0 
statuscode 
statusCode�r  �s  0 n   343 o    �p�p &0 nshttpurlresponse NSHTTPURLResponse4 m    �o
�o misccura�v  �u  - m    �n
�n 
ctxt�w   R      �m56
�m .ascrerr ****      � ****5 o      �l�l 0 etext eText6 �k78
�k 
errn7 o      �j�j 0 enumber eNumber8 �i9:
�i 
erob9 o      �h�h 0 efrom eFrom: �g;�f
�g 
errt; o      �e�e 
0 eto eTo�f   I   $ .�d<�c�d 
0 _error  < =>= m   % &?? �@@   H T T P   s t a t u s   n a m e> ABA o   & '�b�b 0 etext eTextB CDC o   ' (�a�a 0 enumber eNumberD EFE o   ( )�`�` 0 efrom eFromF G�_G o   ) *�^�^ 
0 eto eTo�_  �c   HIH l     �]�\�[�]  �\  �[  I J�ZJ l     �Y�X�W�Y  �X  �W  �Z       �VKLMNOPQRS'TUVWXYZ[\]^_`abc�V  K �U�T�S�R�Q�P�O�N�M�L�K�J�I�H�G�F�E�D�C�B�A�@�?�>�=
�U 
pimr�T 0 _support  �S 
0 _error  �R 0 _usesnetloc _usesNetLoc�Q 0 _ascomponent _asComponent�P ,0 _joinnetworklocation _joinNetworkLocation
�O .Web:SplUnull���     ctxt
�N .Web:JoiUnull���     WebC�M "0 _safecharacters _safeCharacters�L 0 _replacetext _replaceText
�K .Web:EscUnull���     ctxt
�J .Web:UneUnull���     ctxt
�I .Web:SplQnull���     ctxt
�H .Web:JoiQnull���     ****
�G .Web:FJSNnull���     ****
�F .Web:PJSNnull���     ctxt
�E .Web:FB64null���     ctxt
�D .Web:PB64null���     ctxt�C "0 _excludeheaders _excludeHeaders�B (0 _nsstringencodings _NSStringEncodings�A 0 _parsecharset _parseCharset�@ $0 _makehttprequest _makeHTTPRequest�? *0 _unpackhttpresponse _unpackHTTPResponse
�> .Web:ReqHnull��� ��� null
�= .Web:DStCnull���     longL �<d�< d  ee �;f�:
�; 
cobjf gg   �9 
�9 
frmk�:  M hh   �8 *
�8 
scptN �7 4�6�5ij�4�7 
0 _error  �6 �3k�3 k  �2�1�0�/�.�2 0 handlername handlerName�1 0 etext eText�0 0 enumber eNumber�/ 0 efrom eFrom�. 
0 eto eTo�5  i �-�,�+�*�)�- 0 handlername handlerName�, 0 etext eText�+ 0 enumber eNumber�* 0 efrom eFrom�) 
0 eto eToj  D�(�'�( �' &0 throwcommanderror throwCommandError�4 b  ࠡ����+ O �&l�& l   j n r v z ~ � � � � � � � � � � � � � � � � �P �% ��$�#mn�"�% 0 _ascomponent _asComponent�$ �!o�! o  � �  0 
asocstring 
asocString�#  m �� 0 
asocstring 
asocStringn � ��
� 
msng
� 
ctxt�" ��  �Y hO��&Q � ���pq�� ,0 _joinnetworklocation _joinNetworkLocation� �r� r  �� .0 networklocationrecord networkLocationRecord�  p 	���������� .0 networklocationrecord networkLocationRecord� $0 fullnetlocrecord fullNetLocRecord� 0 urlcomponents urlComponents� 0 aref aRef� 0 	urlrecord 	urlRecord� 0 username userName� 0 userpassword userPassword� 0 hostname hostName� 0 
portnumber 
portNumberq (� �� �� ��
 ��	��������s� ����*9=AD��Fbjrx��������� 0 username userName� 0 userpassword userPassword� 0 hostname hostName�
 0 
portnumber 
portNumber�	 � 60 asoptionalrecordparameter asOptionalRecordParameter� 
� 
kocl
� 
cobj
� .corecnte****       ****
� 
pcnt
� 
ctxt�  s ������
�� 
errn���\��  
�  
errn���Y
�� 
erob
�� 
leng
�� 
bool�%b  �����������m+ 
E�O�[�,\[�,\[�,\[�,\Z�vE�O V�[��l kh  ��,a &��,FW 3X  )a a a ��a a a a a �v��a ,k/%a %[OY��O�E[�k/E�Z[�l/E�Z[�m/E�Z[��/E�ZO�a  �a %�%E�Y hO�a  �a  %E�Y hO�a ! 	 �a " 	 �a # a $&a $& )a a a ��a %Y hO��%E�O�a & �a '%�%E�Y hO�R �������tu��
�� .Web:SplUnull���     ctxt�� 0 urltext urlText�� ��v��
�� 
NeLov {�������� ,0 splitnetworklocation splitNetworkLocation��  
�� boovfals��  t ������������������ 0 urltext urlText�� ,0 splitnetworklocation splitNetworkLocation�� 0 asocurl asocURL�� "0 networklocation networkLocation�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTou ����������������������� ����������������������������w2������ $0 asnsurlparameter asNSURLParameter�� 0 username userName�� 0 user  �� 0 _ascomponent _asComponent�� 0 userpassword userPassword�� 0 password  �� 0 hostname hostName�� 0 host  �� 0 
portnumber 
portNumber�� 0 port  �� �� (0 asbooleanparameter asBooleanParameter�� ,0 _joinnetworklocation _joinNetworkLocation�� 0 	urlscheme 	urlScheme�� 
0 scheme  �� "0 networklocation networkLocation�� 0 resourcepath resourcePath�� 0 path  �� "0 parameterstring parameterString�� 0 querystring queryString�� 	0 query  �� (0 fragmentidentifier fragmentIdentifier�� 0 fragment  �� �� 0 etext eTextw ����x
�� 
errn�� 0 enumber eNumberx ����y
�� 
erob�� 0 efrom eFromy ������
�� 
errt�� 
0 eto eTo��  �� �� 
0 _error  �� � �b  ��l+ E�O�*�j+ k+ �*�j+ k+ �*�j+ k+ �*�j+ 
k+ �E�Ob  ��l+  *�k+ E�Y hO�*�j+ k+ a �a *�j+ k+ a *�j+ k+ a *�j+ k+ a *�j+ k+ a W X  *a ����a + S ��D����z{��
�� .Web:JoiUnull���     WebC�� 0 	urlrecord 	urlRecord�� ��|��
�� 
Base| {����K�� 0 baseurl baseURL��  ��  z ������������������������������������ 0 	urlrecord 	urlRecord�� 0 baseurl baseURL�� 0 fullurlrecord fullURLRecord�� 0 urlcomponents urlComponents�� 0 aref aRef�� 0 	urlscheme 	urlScheme�� 0 resourcepath resourcePath�� "0 parameterstring parameterString�� 0 querystring queryString�� (0 fragmentidentifier fragmentIdentifier�� "0 networklocation networkLocation�� 0 urltext urlText�� 0 asocurl asocURL�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo{ LTU��������x��|���������������������������}������������������+��7@��GUZ`it|������������������������������~���
�� 
kocl
�� 
reco
�� .corecnte****       ****�� 0 	urlscheme 	urlScheme�� "0 networklocation networkLocation�� 0 resourcepath resourcePath�� "0 parameterstring parameterString�� 0 querystring queryString�� (0 fragmentidentifier fragmentIdentifier�� �� 60 asoptionalrecordparameter asOptionalRecordParameter�� 
�� 
cobj
�� 
pcnt
�� 
ctxt��  } ������
�� 
errn���\��  
�� 
leng�� �� .0 throwinvalidparameter throwInvalidParameter�� ,0 _joinnetworklocation _joinNetworkLocation
�� 
Safe
�� .Web:EscUnull���     ctxt
�� 
bool�� "0 astextparameter asTextParameter�� $0 asnsurlparameter asNSURLParameter
�� misccura�� 0 nsurl NSURL�� <0 urlwithstring_relativetourl_ URLWithString_relativeToURL_
�� 
msng
�� 
errn���Y
�� 
erob�� 0 etext eText~ ����
�� 
errn�� 0 enumber eNumber �����
�� 
erob�� 0 efrom eFrom� ������
�� 
errt�� 
0 eto eTo��  �� 
0 _error  ��}f��^�kv��l j�b  ������������a a a m+ E�O�[�,\[�,\[�,\[�,\[�,\Za vE�O f�[�a l kh  �a ,a &�a ,FW =X  b  �a �a a a a a a  a va �a !,k/%a "%a #+ $[OY��O�E[a k/E�Z[a l/E�Z[a m/E�Z[a a #/E�Z[a a /E�ZO��,kv��l j *��,k+ %E�Y ) ��,a &E�W X  b  �a &�a 'a #+ $O�a (a )l *E�O�a +
 &�a ,	 b  �a -&	 �a .a -&a -& /�a /	 �a 0a -& a 1�%E�Y hOa 2�%�%E�Y �E�O�a 3 �a 4%�%E�Y hO�a 5 �a 6%�%E�Y hO�a 7 �a 8%�%E�Y hO�a 9 �a :%�%E�Y hY b  �a ;l+ <E�O�a = Kb  �a >l+ ?E�Oa @a A,��l+ BE�O�a C  )a Da Ea F�a #a GY hO�a &E�Y hO�VW X H I*a J���] a + KT ��0��~���}�� 0 _replacetext _replaceText� �|��| �  �{�z�y�{ 0 thetext theText�z 0 fromtext fromText�y 0 totext toText�~  � �x�w�v�u�x 0 thetext theText�w 0 fromtext fromText�v 0 totext toText�u 0 thelist theList� �t�s�r�q
�t 
ascr
�s 
txdl
�r 
citm
�q 
ctxt�} ���,FO��-E�O���,FO��&U �p\�o�n���m
�p .Web:EscUnull���     ctxt�o 0 thetext theText�n �l��k
�l 
Safe� {�j�ic�j &0 allowedcharacters allowedCharacters�i  �k  � �h�g�f�e�d�c�b�a�h 0 thetext theText�g &0 allowedcharacters allowedCharacters�f $0 asocallowedchars asocAllowedChars�e 0 
asocresult 
asocResult�d 0 etext eText�c 0 enumber eNumber�b 0 efrom eFrom�a 
0 eto eTo� s�`��_�^�]�\�[�Z�Y�X�W�V��U�T���S�R�` "0 astextparameter asTextParameter
�_ misccura�^  0 nscharacterset NSCharacterSet�] J0 #charactersetwithcharactersinstring_ #characterSetWithCharactersInString_�\ 0 
asnsstring 
asNSString�[ j0 3stringbyaddingpercentencodingwithallowedcharacters_ 3stringByAddingPercentEncodingWithAllowedCharacters_
�Z 
msng
�Y 
errn�X�Y
�W 
erob�V 
�U 
ctxt�T 0 etext eText� �Q�P�
�Q 
errn�P 0 enumber eNumber� �O�N�
�O 
erob�N 0 efrom eFrom� �M�L�K
�M 
errt�L 
0 eto eTo�K  �S �R 
0 _error  �m p [b  ��l+ E�Ob  b  ��l+ %E�O��,�k+ E�Ob  �k+ �k+ E�O��  )�����Y hO��&W X  *a ����a + V �J��I�H���G
�J .Web:UneUnull���     ctxt�I 0 thetext theText�H  � �F�E�D�C�B�A�F 0 thetext theText�E 0 
asocresult 
asocResult�D 0 etext eText�C 0 enumber eNumber�B 0 efrom eFrom�A 
0 eto eTo� ��@�?�>�=�<�;�:�9��8�7��6�5�@ "0 astextparameter asTextParameter�? 0 
asnsstring 
asNSString�> B0 stringbyremovingpercentencoding stringByRemovingPercentEncoding
�= 
msng
�< 
errn�;�Y
�: 
erob�9 
�8 
ctxt�7 0 etext eText� �4�3�
�4 
errn�3 0 enumber eNumber� �2�1�
�2 
erob�1 0 efrom eFrom� �0�/�.
�0 
errt�/ 
0 eto eTo�.  �6 �5 
0 _error  �G L ;b  ��l+ E�Ob  �k+ j+ E�O��  )�����Y hO��&W X  *������+ W �-#�,�+���*
�- .Web:SplQnull���     ctxt�, 0 	querytext 	queryText�+  � 	�)�(�'�&�%�$�#�"�!�) 0 	querytext 	queryText�( 0 oldtids oldTIDs�' 0 	querylist 	queryList�& 0 aref aRef�% 0 
queryparts 
queryParts�$ 0 etext eText�# 0 enumber eNumber�" 0 efrom eFrom�! 
0 eto eTo� &'� �A�E��L�Z���������z������
�  
ascr
� 
txdl� "0 astextparameter asTextParameter
� 
spac� 0 _replacetext _replaceText
� 
citm
� 
kocl
� 
cobj
� .corecnte****       ****
� 
pcnt
� 
leng
� 
errn��Y
� 
erob� 
� .Web:UneUnull���     ctxt� 0 etext eText� ���
� 
errn� 0 enumber eNumber� ��
�
� 
erob�
 0 efrom eFrom� �	��
�	 
errt� 
0 eto eTo�  � � 
0 _error  �* ��� ���,E�O �*b  ��l+ ��m+ E�O���,FO��-E�O���,FO T�[��l kh ��,E�-E�O�a ,l )a a a �a a Y hO��k/j ��l/j lv��,F[OY��O���,FO�W X  ���,FO*a ����a + VX �������
� .Web:JoiQnull���     ****� 0 	querylist 	queryList�  � 	��� ������������� 0 	querylist 	queryList� 0 oldtids oldTIDs�  0 aref aRef�� 0 kvpair kvPair�� 0 	querytext 	queryText�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo� �������������������������������������+8��@���d����
�� 
ascr
�� 
txdl�� 0 aslist asList
�� 
cobj
�� 
kocl
�� .corecnte****       ****
�� 
pcnt
�� 
list
�� 
leng
�� 
bool
�� 
errn���Y
�� 
erob�� 
�� 
ctxt
�� 
Safe
�� 
spac
�� .Web:EscUnull���     ctxt�� 0 _replacetext _replaceText�� 0 etext eText� �����
�� 
errn�� 0 enumber eNumber� �����
�� 
erob�� 0 efrom eFrom� ������
�� 
errt�� 
0 eto eTo��  �� �� 
0 _error  � ���,E�O �b  ��l+ �-E�O ��[��l kh ��,E�O�kv��l k 	 	��,l �& )������Y hO��a l l  )�����a Y hO*��k/a _ l a %��l/a _ l %_ a m+ ��,F[OY��Oa ��,FO�a &E�O���,FO�W X  ���,FO*a ����a + Y �����������
�� .Web:FJSNnull���     ****�� 0 
jsonobject 
jsonObject�� �����
�� 
EWSp� {�������� "0 isprettyprinted isPrettyPrinted��  
�� boovfals��  � 	�������������������� 0 
jsonobject 
jsonObject�� "0 isprettyprinted isPrettyPrinted�� 0 writeoptions writeOptions�� 0 thedata theData�� 0 theerror theError�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo� ���������������������������������������������������� (0 asbooleanparameter asBooleanParameter
�� misccura�� 80 nsjsonwritingprettyprinted NSJSONWritingPrettyPrinted�� *0 nsjsonserialization NSJSONSerialization�� (0 isvalidjsonobject_ isValidJSONObject_
�� 
errn���Y
�� 
erob�� 
�� 
obj �� F0 !datawithjsonobject_options_error_ !dataWithJSONObject_options_error_
�� 
cobj
�� 
msng�� ,0 localizeddescription localizedDescription�� 0 nsstring NSString�� 	0 alloc  �� ,0 nsutf8stringencoding NSUTF8StringEncoding�� 00 initwithdata_encoding_ initWithData_encoding_
�� 
ctxt�� 0 etext eText� �����
�� 
errn�� 0 enumber eNumber� �����
�� 
erob�� 0 efrom eFrom� ������
�� 
errt�� 
0 eto eTo��  �� �� 
0 _error  �� � �b  ��l+  
��,E�Y jE�O��,�k+  )�����Y hO��,���m+ E[�k/E�Z[�l/E�ZO��  )�����j+ %a %Y hO�a ,j+ ��a ,l+ a &W X  *a ����a + Z ����������
�� .Web:PJSNnull���     ctxt�� 0 jsontext jsonText�� �����
�� 
Frag� {�������� *0 arefragmentsallowed areFragmentsAllowed��  
�� boovfals��  � 
���������������������� 0 jsontext jsonText�� *0 arefragmentsallowed areFragmentsAllowed�� 0 readoptions readOptions�� 0 thedata theData�� 0 
jsonobject 
jsonObject�� 0 theerror theError�� 0 etext eText�� 0 enumber eNumber�� 0 efrom eFrom�� 
0 eto eTo� ��'������������������������������]��a�����t������ "0 astextparameter asTextParameter�� (0 asbooleanparameter asBooleanParameter
�� misccura�� :0 nsjsonreadingallowfragments NSJSONReadingAllowFragments�� 0 
asnsstring 
asNSString�� ,0 nsutf8stringencoding NSUTF8StringEncoding�� (0 datausingencoding_ dataUsingEncoding_�� *0 nsjsonserialization NSJSONSerialization
�� 
obj �� F0 !jsonobjectwithdata_options_error_ !JSONObjectWithData_options_error_
�� 
cobj
�� 
msng
�� 
errn���Y
�� 
erob�� �� ,0 localizeddescription localizedDescription
�� 
****�� 0 etext eText� �����
�� 
errn�� 0 enumber eNumber� �����
�� 
erob�� 0 efrom eFrom� �����
�� 
errt�� 
0 eto eTo�  �� �� 
0 _error  �� � �b  ��l+ E�Ob  ��l+  
��,E�Y jE�Ob  �k+ ��,k+ E�O��,���m+ E[�k/E�Z[�l/E�ZO��  )��a �a a �j+ %a %Y hO�a &W X  *a ����a + [ �~��}�|���{
�~ .Web:FB64null���     ctxt�} 0 thetext theText�|  � �z�y�x�w�v�u�z 0 thetext theText�y 0 
asocstring 
asocString�x 0 etext eText�w 0 enumber eNumber�v 0 efrom eFrom�u 
0 eto eTo� ��t�s�r�q�p�o�n���m�l�t "0 astextparameter asTextParameter�s 0 
asnsstring 
asNSString
�r misccura�q ,0 nsutf8stringencoding NSUTF8StringEncoding�p B0 base64encodedstringwithoptions_ base64EncodedStringWithOptions_�o (0 datausingencoding_ dataUsingEncoding_�n 0 etext eText� �k�j�
�k 
errn�j 0 enumber eNumber� �i�h�
�i 
erob�h 0 efrom eFrom� �g�f�e
�g 
errt�f 
0 eto eTo�e  �m �l 
0 _error  �{ ; *b  b  ��l+ k+ E�O���,jk+ k+ W X  *颣���+ \ �d��c�b���a
�d .Web:PB64null���     ctxt�c 0 thetext theText�b  � �`�_�^�]�\�[�Z�` 0 thetext theText�_ 0 asocdata asocData�^ 0 
asocstring 
asocString�] 0 etext eText�\ 0 enumber eNumber�[ 0 efrom eFrom�Z 
0 eto eTo� ��Y�X�W�V�U�T�S�R�Q�P	�O�N�M�L��K�J�Y "0 astextparameter asTextParameter
�X misccura�W 0 nsdata NSData�V 	0 alloc  �U Z0 +nsdatabase64decodingignoreunknowncharacters +NSDataBase64DecodingIgnoreUnknownCharacters�T L0 $initwithbase64encodedstring_options_ $initWithBase64EncodedString_options_�S 0 nsstring NSString�R ,0 nsutf8stringencoding NSUTF8StringEncoding�Q 00 initwithdata_encoding_ initWithData_encoding_
�P 
msng
�O 
ctxt�N �M .0 throwinvalidparameter throwInvalidParameter�L 0 etext eText� �I�H�
�I 
errn�H 0 enumber eNumber� �G�F�
�G 
erob�F 0 efrom eFrom� �E�D�C
�E 
errt�D 
0 eto eTo�C  �K �J 
0 _error  �a c Nb  ��l+ E�O��,j+ ���,l+ E�O��,j+ ���,l+ 	E�O��  b  �����+ Y hW X  *a ����a + ] �B��B �  <@DHLPS^ �A\  ��A (0 _nsstringencodings _NSStringEncodings�  ��@��� �?�>�=�? 	0 _list  �> 	0 _init  �= 0 getencoding getEncoding
�@ 
msng� �<n�;�:���9�< 	0 _init  �;  �:  �  � E{~�8�7���6���5���4���3���2���1��0�		�/			�.	)	-	0�-	>	B	F	I�,�+	V�*	d	h	k�)	y	}	��(	�	�	��'	�	�	��&	�	�	��%	�	�	��$�#
�8 misccura�7 ,0 nsutf8stringencoding NSUTF8StringEncoding�6 .0 nsutf16stringencoding NSUTF16StringEncoding�5 @0 nsutf16bigendianstringencoding NSUTF16BigEndianStringEncoding�4 F0 !nsutf16littleendianstringencoding !NSUTF16LittleEndianStringEncoding�3 .0 nsutf32stringencoding NSUTF32StringEncoding�2 @0 nsutf32bigendianstringencoding NSUTF32BigEndianStringEncoding�1 F0 !nsutf32littleendianstringencoding !NSUTF32LittleEndianStringEncoding�0 .0 nsasciistringencoding NSASCIIStringEncoding�/ 60 nsiso2022jpstringencoding NSISO2022JPStringEncoding�. 60 nsisolatin1stringencoding NSISOLatin1StringEncoding�- 60 nsisolatin2stringencoding NSISOLatin2StringEncoding�, �+ :0 nsjapaneseeucstringencoding NSJapaneseEUCStringEncoding�* 80 nsmacosromanstringencoding NSMacOSRomanStringEncoding�) 40 nsshiftjisstringencoding NSShiftJISStringEncoding�( >0 nswindowscp1250stringencoding NSWindowsCP1250StringEncoding�' >0 nswindowscp1251stringencoding NSWindowsCP1251StringEncoding�& >0 nswindowscp1252stringencoding NSWindowsCP1252StringEncoding�% >0 nswindowscp1253stringencoding NSWindowsCP1253StringEncoding�$ >0 nswindowscp1254stringencoding NSWindowsCP1254StringEncoding�# �9'��lv��,lv��lv��,lv��lv��,lv��lv��,lv��lv��,lva a lv�a ,lva a lv�a ,lva kv�a ,lva a a mv�a ,lva a a mv�a ,lva  a !a "mv�a #,lva $a %a &a 'a (v�a ),lva *kv�a +,lva ,a -a .mv�a /,lva 0a 1a 2mv�a 3,lva 4a 5a 6mv�a 7,lva 8a 9a :mv�a ;,lva <a =a >mv�a ?,lva @a Aa Bmv�a C,lva DvEc   � �"	��!� ����" 0 getencoding getEncoding�! ��� �  �� 0 textencoding textEncoding�   � ��� 0 textencoding textEncoding� 0 aref aRef� 
��	�	�������
� 
msng� 	0 _init  � 	0 _list  
� 
kocl
� 
cobj
� .corecnte****       ****�  �  � V Nb   �  
*j+ Y hO�� 2 +)�,[��l kh ��k/�kv ��l/EY h[OY��O�VW X  	h_ �
������ 0 _parsecharset _parseCharset� ��� �  �� "0 asoccontenttype asocContentType�  � ���
� "0 asoccontenttype asocContentType� 0 asocpattern asocPattern�
 0 	asocmatch 	asocMatch� 
�	�
�������
�	 misccura� *0 nsregularexpression NSRegularExpression
� 
msng� Z0 +regularexpressionwithpattern_options_error_ +regularExpressionWithPattern_options_error_� 
0 length  � F0 !firstmatchinstring_options_range_ !firstMatchInString_options_range_� 0 rangeatindex_ rangeAtIndex_� *0 substringwithrange_ substringWithRange_
� 
ctxt� ;��,�j�m+ E�O��jj�j+ lvm+ E�O��  �Y hO��lk+ k+ �&` � 
U���������  $0 _makehttprequest _makeHTTPRequest�� ����� �  ������������ 0 theurl theURL�� 0 
httpmethod 
httpMethod��  0 requestheaders requestHeaders�� 0 requestbody requestBody�� $0 timeoutinseconds timeoutInSeconds��  � ���������������������������������������� 0 theurl theURL�� 0 
httpmethod 
httpMethod��  0 requestheaders requestHeaders�� 0 requestbody requestBody�� $0 timeoutinseconds timeoutInSeconds�� 0 httprequest httpRequest�� 0 aref aRef�� 0 headerrecord headerRecord�� 0 
headername 
headerName�� 0 headervalue headerValue�� 0 etext eText�� 0 enum eNum�� 0 efrom eFrom�� 
0 eto eTo�� 0 contenttype contentType�� ,0 nsutf8stringencoding NSUTF8StringEncoding�� *0 requestbodyencoding requestBodyEncoding�� 0 charsetname charsetName�� 0 bodydata bodyData� A
a
b����
x����
���������0�������������������������������������������]��qt����������������������������'*4=
�� misccura�� *0 nsmutableurlrequest NSMutableURLRequest�� $0 asnsurlparameter asNSURLParameter�� "0 requestwithurl_ requestWithURL_�� "0 astextparameter asTextParameter��  0 sethttpmethod_ setHTTPMethod_
�� 
msng�� *0 settimeoutinterval_ setTimeoutInterval_�� "0 aslistparameter asListParameter
�� 
kocl
�� 
cobj
�� .corecnte****       ****
�� 
pcnt
�� 
reco
�� 
ctxt
�� 
errn���Y�� 0 
headername 
headerName�� 0 headervalue headerValue�� 0 etext eText� �����
�� 
errn�� 0 enum eNum� �����
�� 
erob�� 0 efrom eFrom� ������
�� 
errt�� 
0 eto eTo��  ���\���@
�� 
erob
�� 
errt�� 
�� 
list�� �� .0 throwinvalidparameter throwInvalidParameter�� <0 setvalue_forhttpheaderfield_ setValue_forHTTPHeaderField_�� 40 valueforhttpheaderfield_ valueForHTTPHeaderField_�� 0 
asnsstring 
asNSString�� 0 _parsecharset _parseCharset�� 0 getencoding getEncoding�� (0 datausingencoding_ dataUsingEncoding_
�� 
ocid�� 0 sethttpbody_ setHTTPBody_�� &0 checktypeforvalue checkTypeForValue�� 0 nsdata NSData�� 	0 class  �� &0 isinstanceoftype_ isInstanceOfType_
�� 
bool��~��z��,b  ��l+ k+ E�Ob  ��l+ E�O��k+ 	O�� ��k+ Y hO�� � �b  ��l+ [��l kh  I�a ,a &E�O��a l l )a a lhY hO�a ,�a ,lvE[�k/E�Z[�l/E�ZW FX  a a a mv�kv )a �a �a �a �Y hOb  �a a  a !a "+ #Ob  � b  �a $a  a %�%a "+ #Y hO���l+ &[OY�>Y hO��N�kv�a l k  ֥a 'k+ (E�O��  �a )a *l+ &O�E^ Y f*b  �k+ +k+ ,E^ O] �  ��a -%a .l+ &O�E^ Y 4b  ] k+ /E^ O] �  b  �a 0a  a 1a "+ #Y hOb  �k+ +] k+ 2E^ O] �  !b  �a 3a a 4lva 5�%a "+ #Y hO�] k+ 6Y gb  �a 4l+ 7	 ��a 8,j+ 9k+ :a ;& (��k+ 6O�a <� k+ ( �a =a >l+ &Y hY b  �a ?a a 4lva @a "+ #Y hO�Va ��M���������� *0 _unpackhttpresponse _unpackHTTPResponse�� ����� �  �������� 0 httpresponse httpResponse�� $0 responsebodytype responseBodyType�� $0 responsebodydata responseBodyData��  � ������������������������ 0 httpresponse httpResponse�� $0 responsebodytype responseBodyType�� $0 responsebodydata responseBodyData�� 0 headerfields headerFields�� $0 asocheaderfields asocHeaderFields�� 0 
headerkeys 
headerKeys�� 0 i  �� 0 asockey asocKey�� ,0 responsebodyencoding responseBodyEncoding�� "0 asoccontenttype asocContentType�� 0 responsebody responseBody� ������������������������������������������������ "0 allheaderfields allHeaderFields�� 0 allkeys allKeys�� 	0 count  ��  0 objectatindex_ objectAtIndex_�� 0 
headername 
headerName
�� 
ctxt�� 0 headervalue headerValue�� 0 objectforkey_ objectForKey_
�� 
****�� 
�� 
msng�� 0 _parsecharset _parseCharset�� 0 getencoding getEncoding
�� 
errn���\
�� misccura�� 0 nsstring NSString� 	0 alloc  � 00 initwithdata_encoding_ initWithData_encoding_
� 
rdat� 0 copy  � >0 throwinvalidconstantparameter throwInvalidConstantParameter� 0 
statuscode 
statusCode� "0 responseheaders responseHeaders� 0 responsebody responseBody� �� �jvE�O�j+  E�O�j+ E�O /j�j+ kkh ��k+ E�O��&椧k+ �&��6F[OY��O��  V�E�O��k+ E�O�� b  *�k+ k+ E�Y hO��  )��la Y hOa a ,j+ ��l+ �&E�Y -�a   �j+ E�Y ��  �E�Y b  �a l+ Oa �j+ a �a �a b � �����
� .Web:ReqHnull��� ��� null�  � ���
� 
Dest� 0 theurl theURL� ���
� 
Meth� {��~	� 0 
httpmethod 
httpMethod�~  � �}��
�} 
Head� {�|�{�z�|  0 requestheaders requestHeaders�{  �z  � �y��
�y 
Body� {�x�w�v�x 0 requestbody requestBody�w  
�v 
msng� �u��
�u 
TimO� {�t�s�r�t $0 timeoutinseconds timeoutInSeconds�s  
�r 
msng� �q��p
�q 
Type� {�o�n�m�o $0 responsebodytype responseBodyType�n  
�m 
ctxt�p  � �l�k�j�i�h�g�f�e�d�c�b�a�`�_�^�]�\�l 0 theurl theURL�k 0 
httpmethod 
httpMethod�j  0 requestheaders requestHeaders�i 0 requestbody requestBody�h $0 timeoutinseconds timeoutInSeconds�g $0 responsebodytype responseBodyType�f 0 httprequest httpRequest�e 0 sessionconfig sessionConfig�d 0 asocsession asocSession�c $0 responsebodydata responseBodyData�b *0 sessiontaskdelegate sessionTaskDelegate�a 0 asoctask asocTask�` 0 	taskerror 	taskError�_ 0 etext eText�^ 0 enumber eNumber�] 0 efrom eFrom�\ 
0 eto eTo� )�[/�Z�Y�X�W�V�U�T�S�R�Q�P�Ou��N�M�L�K�J�I��H�G�F�E�D�C�B�A�@�?�>�=�<�;�:��9
�[ 
msng�Z (0 asintegerparameter asIntegerParameter�Y �X $0 _makehttprequest _makeHTTPRequest
�W misccura�V 60 nsurlsessionconfiguration NSURLSessionConfiguration�U >0 ephemeralsessionconfiguration ephemeralSessionConfiguration�T >0 settimeoutintervalforrequest_ setTimeoutIntervalForRequest_�S 0 nsurlsession NSURLSession�R 60 sessionwithconfiguration_ sessionWithConfiguration_�Q 0 nsmutabledata NSMutableData�P 0 data  �O *0 sessiontaskdelegate sessionTaskDelegate� �8��7�6���5
�8 .ascrinit****      � ****� k     �� u�4�4  �7  �6  � �3�3 J0 #urlsession_datatask_didreceivedata_ #URLSession_dataTask_didReceiveData_� �� �2w�1�0���/�2 J0 #urlsession_datatask_didreceivedata_ #URLSession_dataTask_didReceiveData_�1 �.��. �  �-�,�+�- 0 asocsession asocSession�, 0 asoctask asocTask�+ 0 asocdata asocData�0  � �*�)�(�* 0 asocsession asocSession�) 0 asoctask asocTask�( 0 asocdata asocData� �'�' 0 appenddata_ appendData_�/ b  	�k+  �5 L  �N d0 0sessionwithconfiguration_delegate_delegatequeue_ 0sessionWithConfiguration_delegate_delegateQueue_�M ,0 datataskwithrequest_ dataTaskWithRequest_�L 
0 resume  �K 	0 state  �J <0 nsurlsessiontaskstaterunning NSURLSessionTaskStateRunning�I 0 nsthread NSThread�H .0 sleepfortimeinterval_ sleepForTimeInterval_�G @0 nsurlsessiontaskstatesuspended NSURLSessionTaskStateSuspended�F 
0 cancel  �E @0 nsurlsessiontaskstatecanceling NSURLSessionTaskStateCanceling
�D 
errn�C���B 	0 error  �A 0 code  
�@ 
erob�? �> ,0 localizeddescription localizedDescription
�= 
ctxt�< 0 response  �; *0 _unpackhttpresponse _unpackHTTPResponse�: 0 etext eText� �&�%�
�& 
errn�% 0 enumber eNumber� �$�#�
�$ 
erob�# 0 efrom eFrom� �"�!� 
�" 
errt�! 
0 eto eTo�   �9 
0 _error  �0�� b  ��l+ E�Y hO*������+ E�O��,j+ E�O�� ��k+ Y hO��  ��,�k+ 
E�O�E�Y  ��,j+ E�O��K S�O��,���m+ E�O��k+ E�O�j+ O  h�j+ �a , �a ,a k+ [OY��O�j+ �a ,  
�j+ Y hO�j+ �a ,  )a a lhY hO�j+ E�O�� )a �j+ a �a  �j+ !a "&Y hO*�j+ #��m+ $W X % &*a '���] �+ (c ������
� .Web:DStCnull���     long� 0 
statuscode 
statusCode�  � ������ 0 
statuscode 
statusCode� 0 etext eText� 0 enumber eNumber� 0 efrom eFrom� 
0 eto eTo� (�������?��� (0 asintegerparameter asIntegerParameter
� misccura� &0 nshttpurlresponse NSHTTPURLResponse� >0 localizedstringforstatuscode_ localizedStringForStatusCode_
� 
ctxt� 0 etext eText� ���
� 
errn� 0 enumber eNumber� ���
� 
erob� 0 efrom eFrom� �
�	�
�
 
errt�	 
0 eto eTo�  � � 
0 _error  � / b  ��l+ E�O��,�k+ �&W X  *衢���+ 
ascr  ��ޭ