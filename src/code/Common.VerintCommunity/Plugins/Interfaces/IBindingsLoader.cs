using DryIoc;

namespace FourRoads.Common.VerintCommunity.Plugins.Interfaces
{
    public interface IBindingsLoader
    {
        void LoadBindings(IContainer container);
        int LoadOrder { get; }
    }
}
