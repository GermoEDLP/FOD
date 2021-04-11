program tp2_13;
 uses Crt, sysutils;
	const valor_alto = 9999;
	type
        str40 = string[40];
		log = record
			n_user: integer;
			nick: str40;
			nombre: str40;
            apellido: str40;
            cantEmail: integer;
	  	end;
        email = record
            n_user:integer;
            para: str40;
            body: str40;
        end;

	logs = file of log;
    emails = file of email;

procedure leer(var archivo: emails; var dato: email);
begin
	if (not(EOF(archivo))) then 
		read (archivo, dato)
	else 
		dato.n_user:= valor_alto;
end;

procedure importarMaestro();
var
    archivo: logs;
    reg: log;
    texto: Text;
begin
    assign(archivo, 'dataEj13/var/log/logmail.dat');
    rewrite(archivo);
    assign(texto, 'dataEj13/var/log/logmail.txt');
    reset(texto);
    while(not eof(texto)) do begin
        // n_user nombre  
        // nick
        // cantEmail apellido
        readln(texto, reg.n_user, reg.nombre);
        readln(texto, reg.nick);
        readln(texto, reg.cantEmail, reg.apellido);
        write(archivo, reg);
    end;
    close(archivo);
    close(texto);
    writeln('Archivo maestro importado correctamente!!');
    writeln();
end;

procedure importarDetalle();
var
    archivo: emails;
    reg: email;
    texto: Text;
begin
    assign(archivo, 'dataEj13/dia.dat');
    rewrite(archivo);
    assign(texto, 'dataEj13/dia.txt');
    reset(texto);
    while(not eof(texto)) do begin
        // n_user para
        // body
        readln(texto, reg.n_user, reg.para);
        readln(texto, reg.body);
        write(archivo, reg);
    end;
    close(archivo);
    close(texto);
    writeln('Archivo diario importado correctamente!!');
    writeln();
end;

procedure actualizarMaestro();
var
    det: emails;
    regd: email;
    mae: logs;
    regm: log;
    texto: Text;
    n_user, cant_email: integer;
begin
    assign(det, 'dataEj13/dia.dat');
    reset(det);
    assign(mae, 'dataEj13/var/log/logmail.dat');
    reset(mae);
    assign(texto, 'dataEj13/reporte.txt');
    rewrite(texto);
    read(mae, regm);
    leer(det, regd);
    while (regd.n_user <> valor_alto)do begin
        n_user:=regd.n_user;
        cant_email:=0;
        while(n_user=regd.n_user)do begin
            cant_email:=cant_email+1;
            leer(det, regd);
        end;
        // writeln('Usuario ', n_user, ' | Mensajes enviados: ', cant_email);
        while(regm.n_user<>n_user) do begin
            writeln(texto, 'Usuario: ', regm.n_user, ' | Mensajes enviados: ', regm.cantEmail);
            read(mae, regm);
        end;
        regm.cantEmail:=regm.cantEmail+cant_email;
        writeln(texto, 'Usuario: ', regm.n_user, ' | Mensajes enviados: ', regm.cantEmail);
        seek(mae, filepos(mae)-1);
        write(mae, regm);
        if(not eof(mae)) then
            read(mae, regm);
    end;
    close(mae);
    close(det);
    close(texto);
    writeln('Archivo maestro actualizado en base a registro diario!!');
    writeln();
    writeln('Reporte creado!!');
    writeln();
end;

begin
    importarMaestro();
    writeln('Presione ENTER para importar los detalles.');
    readln();
    importarDetalle();
    writeln('Presione ENTER para actualizar el maestro y generar reporte.');
    readln();
    actualizarMaestro();
end.

