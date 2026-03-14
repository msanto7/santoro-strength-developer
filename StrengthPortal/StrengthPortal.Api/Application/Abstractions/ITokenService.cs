namespace StrengthPortal.Api.Application.Abstractions;

public interface ITokenService
{
    string CreateToken(int userId, string email, string fullName);
}
