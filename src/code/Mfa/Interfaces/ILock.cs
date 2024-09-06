using System;

namespace FourRoads.VerintCommunity.Mfa.Interfaces
{
    public interface ILock<T>
    {
        IDisposable Enter(T id);
    }
}