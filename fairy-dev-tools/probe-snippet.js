      try {
        const probeChat = snapshot?.chat;
        window.__fairyProbe = {
          hasSnapshot: !!snapshot,
          snapshotKeys: snapshot ? Object.keys(snapshot).slice(0, 24) : [],
          hasChat: !!probeChat,
          chatKeys: probeChat ? Object.keys(probeChat).slice(0, 24) : [],
          orderIsArray: Array.isArray(probeChat?.order),
          orderLength: probeChat?.order ? probeChat.order.length : null,
          nodesType: probeChat?.nodes ? Object.prototype.toString.call(probeChat.nodes) : null,
          nodesIsMap: probeChat?.nodes instanceof Map,
          nodesGetType: typeof probeChat?.nodes?.get,
          legacyNodesIsArray: Array.isArray(probeChat?.legacy?.nodes),
          legacyNodesLength: probeChat?.legacy?.nodes ? probeChat.legacy.nodes.length : null,
          sessionId: snapshot?.sessionId ?? probeChat?.sessionId ?? probeChat?.id ?? null,
          firstNodeKinds: (() => {
            try {
              const order = probeChat?.order || [];
              const nodes = probeChat?.nodes;
              return order.slice(0, 8).map((key) => {
                const node = nodes && typeof nodes.get === 'function' ? nodes.get(key) : nodes ? nodes[key] : null;
                return node ? node.kind + ':' + (node.data && node.data.status ? node.data.status : '?') : 'missing';
              });
            } catch (error) { return 'err:' + error.message; }
          })(),
        };
      } catch (error) { window.__fairyProbe = { failed: String(error && error.message) }; }
