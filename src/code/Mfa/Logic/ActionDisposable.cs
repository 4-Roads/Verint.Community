using System;

namespace FourRoads.VerintCommunity.Mfa.Logic
{
    public class ActionDisposable : IDisposable
    {
        private readonly Action action;

        public ActionDisposable(Action action)
        {
            if (action == null)
            {
                throw new ArgumentNullException("action");
            }

            this.action = action;
        }

        public void Dispose()
        {
            action();
        }
    }
}