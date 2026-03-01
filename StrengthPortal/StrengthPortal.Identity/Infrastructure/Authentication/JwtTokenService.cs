using Microsoft.IdentityModel.Tokens;
using StrengthPortal.Identity.Application.Abstractions;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace StrengthPortal.Identity.Infrastructure.Authentication;

public sealed class JwtTokenService(IConfiguration configuration) : ITokenService
{
    public string CreateToken(int userId, string email, string fullName)
    {
        var jwtSection = configuration.GetSection("Jwt");
        var secret = jwtSection["Secret"] ?? throw new InvalidOperationException("Jwt:Secret is missing.");
        var issuer = jwtSection["Issuer"] ?? throw new InvalidOperationException("Jwt:Issuer is missing.");
        var audience = jwtSection["Audience"] ?? throw new InvalidOperationException("Jwt:Audience is missing.");
        var expiryMinutes = int.TryParse(jwtSection["ExpiryMinutes"], out var minutes) ? minutes : 60;

        var claims = new List<Claim>
        {
            new(JwtRegisteredClaimNames.Sub, userId.ToString()),
            new(JwtRegisteredClaimNames.Email, email),
            new(JwtRegisteredClaimNames.Name, fullName),
            new(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
        };

        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secret));
        var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        var token = new JwtSecurityToken(
            issuer: issuer,
            audience: audience,
            claims: claims,
            expires: DateTime.UtcNow.AddMinutes(expiryMinutes),
            signingCredentials: credentials);

        return new JwtSecurityTokenHandler().WriteToken(token);
    }
}
