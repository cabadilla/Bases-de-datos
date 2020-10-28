declare @doc xml
set @doc='
		<Beneficiarios>
			<Beneficiario NumeroCuenta="11000001" ValorDocumentoIdentidadBeneficiario="117370445" ParentezcoId="5" Porcentaje="25" />
			<Beneficiario NumeroCuenta="11461191" ValorDocumentoIdentidadBeneficiario="105711321" ParentezcoId="7" Porcentaje="87"/>
			<Beneficiario NumeroCuenta="11717523" ValorDocumentoIdentidadBeneficiario="153062089" ParentezcoId="1" Porcentaje="74"/>
			<Beneficiario NumeroCuenta="11260649" ValorDocumentoIdentidadBeneficiario="150205835" ParentezcoId="3" Porcentaje="36"/>
			<Beneficiario NumeroCuenta="11013939" ValorDocumentoIdentidadBeneficiario="168556538" ParentezcoId="7" Porcentaje="10"/>
			<Beneficiario NumeroCuenta="11857673" ValorDocumentoIdentidadBeneficiario="110839943" ParentezcoId="2" Porcentaje="10"/>
			<Beneficiario NumeroCuenta="11688942" ValorDocumentoIdentidadBeneficiario="152348362" ParentezcoId="3" Porcentaje="51"/>
			<Beneficiario NumeroCuenta="11665553" ValorDocumentoIdentidadBeneficiario="153816920" ParentezcoId="4" Porcentaje="59"/>
			<Beneficiario NumeroCuenta="11010717" ValorDocumentoIdentidadBeneficiario="106261426" ParentezcoId="1" Porcentaje="46"/>
			<Beneficiario NumeroCuenta="11943543" ValorDocumentoIdentidadBeneficiario="122111670" ParentezcoId="4" Porcentaje="24"/>
			<Beneficiario NumeroCuenta="11090371" ValorDocumentoIdentidadBeneficiario="117359964" ParentezcoId="3" Porcentaje="27"/>
			<Beneficiario NumeroCuenta="11857673" ValorDocumentoIdentidadBeneficiario="128965552" ParentezcoId="8" Porcentaje="90"/>
			<Beneficiario NumeroCuenta="11717598" ValorDocumentoIdentidadBeneficiario="144488000" ParentezcoId="3" Porcentaje="43"/>
			<Beneficiario NumeroCuenta="11717523" ValorDocumentoIdentidadBeneficiario="169098517" ParentezcoId="2" Porcentaje="26"/>
			<Beneficiario NumeroCuenta="11559857" ValorDocumentoIdentidadBeneficiario="177230015" ParentezcoId="6" Porcentaje="53"/>
			<Beneficiario NumeroCuenta="11717598" ValorDocumentoIdentidadBeneficiario="174329739" ParentezcoId="2" Porcentaje="27"/>
			<Beneficiario NumeroCuenta="11656323" ValorDocumentoIdentidadBeneficiario="199403646" ParentezcoId="5" Porcentaje="1"/>
			<Beneficiario NumeroCuenta="11090371" ValorDocumentoIdentidadBeneficiario="131927856" ParentezcoId="1" Porcentaje="68"/>
			<Beneficiario NumeroCuenta="11245285" ValorDocumentoIdentidadBeneficiario="165553974" ParentezcoId="8" Porcentaje="51"/>
			<Beneficiario NumeroCuenta="11392498" ValorDocumentoIdentidadBeneficiario="138597348" ParentezcoId="3" Porcentaje="62"/>
			<Beneficiario NumeroCuenta="11405188" ValorDocumentoIdentidadBeneficiario="177230015" ParentezcoId="4" Porcentaje="15"/>
			<Beneficiario NumeroCuenta="11047707" ValorDocumentoIdentidadBeneficiario="143217478" ParentezcoId="7" Porcentaje="100"/>
			<Beneficiario NumeroCuenta="11946763" ValorDocumentoIdentidadBeneficiario="180881845" ParentezcoId="8" Porcentaje="75"/>
			<Beneficiario NumeroCuenta="11717598" ValorDocumentoIdentidadBeneficiario="131927856" ParentezcoId="1" Porcentaje="21"/>
			<Beneficiario NumeroCuenta="11013939" ValorDocumentoIdentidadBeneficiario="125000522" ParentezcoId="1" Porcentaje="90"/>
			<Beneficiario NumeroCuenta="11592082" ValorDocumentoIdentidadBeneficiario="179934028" ParentezcoId="7" Porcentaje="3"/>
			<Beneficiario NumeroCuenta="11893632" ValorDocumentoIdentidadBeneficiario="118882593" ParentezcoId="2" Porcentaje="63"/>
			<Beneficiario NumeroCuenta="11046419" ValorDocumentoIdentidadBeneficiario="133186390" ParentezcoId="8" Porcentaje="61"/>
			<Beneficiario NumeroCuenta="11107814" ValorDocumentoIdentidadBeneficiario="182017351" ParentezcoId="8" Porcentaje="80"/>
			<Beneficiario NumeroCuenta="11717598" ValorDocumentoIdentidadBeneficiario="136191600" ParentezcoId="7" Porcentaje="9"/>
			<Beneficiario NumeroCuenta="11260649" ValorDocumentoIdentidadBeneficiario="169618231" ParentezcoId="7" Porcentaje="64"/>
			<Beneficiario NumeroCuenta="11385711" ValorDocumentoIdentidadBeneficiario="105711321" ParentezcoId="4" Porcentaje="13"/>
			<Beneficiario NumeroCuenta="11887844" ValorDocumentoIdentidadBeneficiario="118343518" ParentezcoId="3" Porcentaje="93"/>
			<Beneficiario NumeroCuenta="11550097" ValorDocumentoIdentidadBeneficiario="149892757" ParentezcoId="7" Porcentaje="66"/>
			<Beneficiario NumeroCuenta="11177296" ValorDocumentoIdentidadBeneficiario="110852503" ParentezcoId="7" Porcentaje="64"/>
			<Beneficiario NumeroCuenta="11550097" ValorDocumentoIdentidadBeneficiario="131567071" ParentezcoId="5" Porcentaje="34"/>
			<Beneficiario NumeroCuenta="11912657" ValorDocumentoIdentidadBeneficiario="108487167" ParentezcoId="1" Porcentaje="30"/>
			<Beneficiario NumeroCuenta="11117419" ValorDocumentoIdentidadBeneficiario="160713985" ParentezcoId="3" Porcentaje="71"/>
			<Beneficiario NumeroCuenta="11331999" ValorDocumentoIdentidadBeneficiario="182017351" ParentezcoId="4" Porcentaje="57"/>
			<Beneficiario NumeroCuenta="11276446" ValorDocumentoIdentidadBeneficiario="139813320" ParentezcoId="8" Porcentaje="9"/>
			<Beneficiario NumeroCuenta="11554662" ValorDocumentoIdentidadBeneficiario="163482829" ParentezcoId="7" Porcentaje="38"/>
			<Beneficiario NumeroCuenta="11554662" ValorDocumentoIdentidadBeneficiario="113219168" ParentezcoId="7" Porcentaje="62"/>
			<Beneficiario NumeroCuenta="11926871" ValorDocumentoIdentidadBeneficiario="108487167" ParentezcoId="7" Porcentaje="10"/>
			<Beneficiario NumeroCuenta="11688942" ValorDocumentoIdentidadBeneficiario="153062089" ParentezcoId="7" Porcentaje="5"/>
			<Beneficiario NumeroCuenta="11580263" ValorDocumentoIdentidadBeneficiario="146448431" ParentezcoId="1" Porcentaje="94"/>
			<Beneficiario NumeroCuenta="11887844" ValorDocumentoIdentidadBeneficiario="106261426" ParentezcoId="1" Porcentaje="7"/>
			<Beneficiario NumeroCuenta="11316046" ValorDocumentoIdentidadBeneficiario="111266789" ParentezcoId="8" Porcentaje="6"/>
			<Beneficiario NumeroCuenta="11534267" ValorDocumentoIdentidadBeneficiario="108487167" ParentezcoId="5" Porcentaje="15"/>
			<Beneficiario NumeroCuenta="11335073" ValorDocumentoIdentidadBeneficiario="153816920" ParentezcoId="5" Porcentaje="7"/>
			<Beneficiario NumeroCuenta="11383961" ValorDocumentoIdentidadBeneficiario="180881845" ParentezcoId="3" Porcentaje="85"/>
			<Beneficiario NumeroCuenta="11469827" ValorDocumentoIdentidadBeneficiario="167231980" ParentezcoId="1" Porcentaje="4"/>
			<Beneficiario NumeroCuenta="11926871" ValorDocumentoIdentidadBeneficiario="163663784" ParentezcoId="7" Porcentaje="90"/>
			<Beneficiario NumeroCuenta="11665553" ValorDocumentoIdentidadBeneficiario="174808854" ParentezcoId="5" Porcentaje="41"/>
			<Beneficiario NumeroCuenta="11316046" ValorDocumentoIdentidadBeneficiario="161104984" ParentezcoId="6" Porcentaje="33"/>
			<Beneficiario NumeroCuenta="11177296" ValorDocumentoIdentidadBeneficiario="159471918" ParentezcoId="7" Porcentaje="36"/>
			<Beneficiario NumeroCuenta="11373328" ValorDocumentoIdentidadBeneficiario="101995117" ParentezcoId="5" Porcentaje="31"/>
			<Beneficiario NumeroCuenta="11810863" ValorDocumentoIdentidadBeneficiario="106261426" ParentezcoId="6" Porcentaje="91"/>
			<Beneficiario NumeroCuenta="11943543" ValorDocumentoIdentidadBeneficiario="165057936" ParentezcoId="7" Porcentaje="54"/>
			<Beneficiario NumeroCuenta="11810863" ValorDocumentoIdentidadBeneficiario="110839943" ParentezcoId="3" Porcentaje="9"/>
			<Beneficiario NumeroCuenta="11376583" ValorDocumentoIdentidadBeneficiario="145224763" ParentezcoId="4" Porcentaje="66"/>
			<Beneficiario NumeroCuenta="11208369" ValorDocumentoIdentidadBeneficiario="158453180" ParentezcoId="7" Porcentaje="64"/>
			<Beneficiario NumeroCuenta="11534267" ValorDocumentoIdentidadBeneficiario="163482829" ParentezcoId="1" Porcentaje="42"/>
			<Beneficiario NumeroCuenta="11108731" ValorDocumentoIdentidadBeneficiario="118343518" ParentezcoId="5" Porcentaje="27"/>
			<Beneficiario NumeroCuenta="11727944" ValorDocumentoIdentidadBeneficiario="150445262" ParentezcoId="2" Porcentaje="46"/>
			<Beneficiario NumeroCuenta="11481862" ValorDocumentoIdentidadBeneficiario="178375881" ParentezcoId="2" Porcentaje="47"/>
			<Beneficiario NumeroCuenta="11514529" ValorDocumentoIdentidadBeneficiario="108487167" ParentezcoId="7" Porcentaje="30"/>
			<Beneficiario NumeroCuenta="11662844" ValorDocumentoIdentidadBeneficiario="122111670" ParentezcoId="7" Porcentaje="50"/>
			<Beneficiario NumeroCuenta="11534267" ValorDocumentoIdentidadBeneficiario="128965552" ParentezcoId="6" Porcentaje="10"/>
			<Beneficiario NumeroCuenta="11744607" ValorDocumentoIdentidadBeneficiario="189149822" ParentezcoId="4" Porcentaje="98"/>
			<Beneficiario NumeroCuenta="11316046" ValorDocumentoIdentidadBeneficiario="100673640" ParentezcoId="2" Porcentaje="17"/>
			<Beneficiario NumeroCuenta="11493715" ValorDocumentoIdentidadBeneficiario="174808854" ParentezcoId="2" Porcentaje="93"/>
			<Beneficiario NumeroCuenta="11164352" ValorDocumentoIdentidadBeneficiario="143062990" ParentezcoId="1" Porcentaje="4"/>
			<Beneficiario NumeroCuenta="11053263" ValorDocumentoIdentidadBeneficiario="138597348" ParentezcoId="7" Porcentaje="67"/>
			<Beneficiario NumeroCuenta="11687607" ValorDocumentoIdentidadBeneficiario="165057936" ParentezcoId="2" Porcentaje="58"/>
			<Beneficiario NumeroCuenta="11743285" ValorDocumentoIdentidadBeneficiario="145019786" ParentezcoId="7" Porcentaje="74"/>
			<Beneficiario NumeroCuenta="11335073" ValorDocumentoIdentidadBeneficiario="122111670" ParentezcoId="4" Porcentaje="8"/>
			<Beneficiario NumeroCuenta="11276446" ValorDocumentoIdentidadBeneficiario="111266789" ParentezcoId="7" Porcentaje="20"/>
			<Beneficiario NumeroCuenta="11912657" ValorDocumentoIdentidadBeneficiario="182157649" ParentezcoId="5" Porcentaje="70"/>
			<Beneficiario NumeroCuenta="11024586" ValorDocumentoIdentidadBeneficiario="117359964" ParentezcoId="8" Porcentaje="36"/>
			<Beneficiario NumeroCuenta="11184977" ValorDocumentoIdentidadBeneficiario="134914730" ParentezcoId="7" Porcentaje="69"/>
			<Beneficiario NumeroCuenta="11589772" ValorDocumentoIdentidadBeneficiario="111266789" ParentezcoId="1" Porcentaje="49"/>
			<Beneficiario NumeroCuenta="11718078" ValorDocumentoIdentidadBeneficiario="147441451" ParentezcoId="7" Porcentaje="67"/>
			<Beneficiario NumeroCuenta="11327131" ValorDocumentoIdentidadBeneficiario="110852503" ParentezcoId="7" Porcentaje="26"/>
			<Beneficiario NumeroCuenta="11662844" ValorDocumentoIdentidadBeneficiario="153816920" ParentezcoId="1" Porcentaje="8"/>
			<Beneficiario NumeroCuenta="11316046" ValorDocumentoIdentidadBeneficiario="149892757" ParentezcoId="4" Porcentaje="34"/>
			<Beneficiario NumeroCuenta="11385711" ValorDocumentoIdentidadBeneficiario="165057936" ParentezcoId="2" Porcentaje="87"/>
			<Beneficiario NumeroCuenta="11245285" ValorDocumentoIdentidadBeneficiario="169618231" ParentezcoId="6" Porcentaje="49"/>
			<Beneficiario NumeroCuenta="11589496" ValorDocumentoIdentidadBeneficiario="152668209" ParentezcoId="4" Porcentaje="35"/>
			<Beneficiario NumeroCuenta="11683263" ValorDocumentoIdentidadBeneficiario="195864670" ParentezcoId="7" Porcentaje="41"/>
			<Beneficiario NumeroCuenta="11376583" ValorDocumentoIdentidadBeneficiario="110852503" ParentezcoId="7" Porcentaje="6"/>
			<Beneficiario NumeroCuenta="11572464" ValorDocumentoIdentidadBeneficiario="147441451" ParentezcoId="6" Porcentaje="85"/>
			<Beneficiario NumeroCuenta="11580263" ValorDocumentoIdentidadBeneficiario="106261426" ParentezcoId="4" Porcentaje="4"/>
  </Beneficiarios>
		'
insert into DBO.Beneficiario(idCuentaAhorros,valorDocumentoIdentidad,idParentezco,porcentaje)
select 
	x.Rec.value('@NumeroCuenta','int'),
    x.Rec.value('@ValorDocumentoIdentidad','int'),
	x.Rec.value('@ParentezcoId','int'),
	x.Rec.value('@Porcentaje','int')
from @doc.nodes('/Beneficiarios/Beneficiario') as x(Rec)


