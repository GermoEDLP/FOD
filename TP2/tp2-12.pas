program tp2_12;
 uses Crt, sysutils;
	const valor_alto = 9999;
	type
		registro = record
			ano: integer;
			mes: integer;
			dia: integer;
            idUsuario: integer;
            tiempo: integer;
	  	end;
	accesos = file of registro;

procedure leer(var archivo: accesos; var dato: registro);
begin
	if (not(EOF(archivo))) then 
		read (archivo, dato)
	else 
		dato.ano:= valor_alto;
end;

procedure importar();
var
    archivo: accesos;
    reg: registro;
    texto: Text;
begin
    assign(archivo, 'dataEj12/accesos.dat');
    rewrite(archivo);
    assign(texto, 'dataEj12/accesos.txt');
    reset(texto);
    while(not eof(texto)) do begin
        //ano mes dia idUsuario tiempo
        readln(texto, reg.ano, reg.mes, reg.dia, reg.idUsuario, reg.tiempo);
        write(archivo, reg);
    end;
    close(archivo);
    close(texto);
    writeln('Archivo accesos.txt importado correctamente!!');
    writeln();
end;

var
    archivo: accesos;
    reg: registro;
    aSS: string[20];
    anoSeleccionado: integer;
    totAno, totMes, totDia, totUser, dia, ano, mes, user: integer;
begin
    importar();
    writeln('Ingrese el año a evaluar: .');
    readln(aSS);
    anoSeleccionado:=StrToInt(aSS);
    assign(archivo, 'dataEj12/accesos.dat');
    reset(archivo);
    leer(archivo, reg);
    while((reg.ano<>valor_alto) and (reg.ano<>anoSeleccionado))do
        leer(archivo, reg);
    
    if(not eof(archivo))then begin
        while ((reg.ano <> valor_alto) and (reg.ano=anoSeleccionado))do begin
            totAno:=0;
            ano:= reg.ano;
            writeln('Año: ', ano);
            while(ano=reg.ano)do begin
                totMes:=0;
                mes:=reg.mes;
                writeln('   Mes: ', mes);
                while((ano=reg.ano) and (mes=reg.mes)) do begin
                    totDia:=0;
                    dia:=reg.dia;
                    writeln('       Dia: ', dia);
                    while((ano=reg.ano) and (mes=reg.mes) and (dia=reg.dia)) do begin
                        totUser:=0;
                        user:=reg.idUsuario;
                        while((ano=reg.ano) and (mes=reg.mes) and (dia=reg.dia) and (user=reg.idUsuario)) do begin
                            totUser:=totUser+reg.tiempo;
                            leer(archivo, reg);
                        end;
                        writeln('           idUsuario ', user, 'Tiempo total en el dia ', dia, ' del mes ', mes, ': ', totUser, 'seg');
                        totDia:=totDia+totUser;
                    end;
                    writeln('       Tiempo total del dia ',dia, ' del mes ',mes,': ',totDia,'seg');
                    totMes:=totMes+totDia;
                end;
                writeln('   Tiempo total del mes ',mes,': ',totMes,'seg');
                totAno:=totAno+totMes;
            end;
            writeln('Tiempo total del ano ',ano,': ',totAno,'seg');
        end;
    end
    else begin
        writeln('Año no encontrado');
    end;
    
end.