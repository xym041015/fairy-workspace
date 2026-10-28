      try {
        const probeHook = (hook, name) => {
          if (typeof hook !== 'function') return { name, missing: true };
          try {
            const value = hook((state) => state);
            return {
              name,
              type: Object.prototype.toString.call(value),
              keys: value && typeof value === 'object' ? Object.keys(value).slice(0, 26) : [],
              sample: (() => { try { return JSON.stringify(value).slice(0, 600); } catch (error) { return 'unserializable'; } })(),
            };
          } catch (error) { return { name, error: String(error && error.message) }; }
        };
        window.__fairyHooks = [probeHook(useChat, 'useChat'), probeHook(useProjection, 'useProjection'), probeHook(useTrajectory, 'useTrajectory'), probeHook(useConversation, 'useConversation')];
      } catch (error) { window.__fairyHooks = { failed: String(error && error.message) }; }
