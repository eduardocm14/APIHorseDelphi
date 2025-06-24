unit uHTTPStatusPrioridade;

interface

type
  // Constantes para níveis de prioridade
  TPrioridade = record
  const
    Baixo = 1;
    Medio = 2;
    Alto  = 3;
  end;

  // Constantes para códigos HTTP
  THTTPStatus = record
  const
    OK                    = 200;
    Created               = 201;
    NoContent             = 204;
    BadRequest            = 400;
    Unauthorized          = 401;
    NotFound              = 404;
    InternalServerError   = 500;
  end;

implementation

end.

