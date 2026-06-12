const $ = (s, el = document) => el.querySelector(s);
const $$ = (s, el = document) => Array.from(el.querySelectorAll(s));

const state = {
  categories: [],
  currentCat: null,
  selectedModel: {},  // { catId: modelId }  guarda qual modelo esta aberto por categoria
  cart: {},           // { slot: { ... } }
  search: "",
};

function post(name, data = {}) {
  return fetch(`https://${GetParentResourceName ? GetParentResourceName() : 'lojaroupas'}/${name}`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(data),
  }).then(r => r.json().catch(() => ({})));
}

function fmt(v) {
  if (!v || v === 0) return "R$ 0";
  return "R$ " + Number(v).toLocaleString("pt-BR");
}
function pad(n){ return String(n).padStart(3,"0"); }

function showToast(msg, kind = "ok") {
  const t = $("#toast");
  t.textContent = msg;
  t.className = "toast show " + kind;
  setTimeout(() => (t.className = "toast"), 2200);
}

function currentCat() {
  return state.categories.find(c => c.id === state.currentCat);
}

/* ---------- CATEGORIAS ---------- */
function renderCategories() {
  const nav = $("#categories");
  nav.innerHTML = "";
  state.categories.forEach(cat => {
    const el = document.createElement("div");
    el.className = "cat" + (cat.id === state.currentCat ? " active" : "");
    el.innerHTML = `<i class="${cat.icon}"></i><span>${cat.label}</span><span class="count">${cat.models.length}</span>`;
    el.onclick = () => {
      state.currentCat = cat.id;
      post("setFocus", { id: cat.id });
      closeVariations();
      renderCategories();
      renderItems();
    };
    nav.appendChild(el);
  });
}

/* ---------- ITENS (MODELOS) ---------- */
function renderItems() {
  const cat = currentCat();
  if (!cat) return;
  $("#catTitle").textContent = cat.label;

  const wrap = $("#items");
  wrap.innerHTML = "";
  const q = state.search.toLowerCase().trim();
  const cartEntry = state.cart[cat.slot];

  cat.models.forEach(model => {
    if (q) {
      const idStr = pad(model.id < 0 ? 0 : model.id);
      if (!idStr.includes(q) && !model.nome.toLowerCase().includes(q)) return;
    }
    const isActive = cartEntry && cartEntry.modelId === model.id;
    const first = model.variations[0] || { preco: 0 };
    const el = document.createElement("div");
    el.className = "item" + (isActive ? " active" : "") + (model.isNone ? " none" : "");
    const displayId = model.isNone ? "—" : pad(model.id);
    const cores = model.variations.length;
    // Tenta carregar imagem da pasta images/<slot>_<drawable>.png  (fallback: ícone)
    const imgSrc = model.isNone ? "" : `images/${cat.slot}_${model.id}.png`;
    el.innerHTML = `
      <div class="id">${displayId}</div>
      ${cores > 1 ? `<div class="badge">${cores}</div>` : ``}
      <div class="thumb">
        ${imgSrc ? `<img src="${imgSrc}" onerror="this.style.display='none';this.nextElementSibling.style.display='flex'" />` : ``}
        <div class="ico" ${imgSrc ? 'style="display:none"' : ''}><i class="${cat.icon}"></i></div>
      </div>
      <div class="price">${fmt(first.preco)}</div>
    `;
    el.onclick = () => onModelClick(cat, model);
    wrap.appendChild(el);
  });


  if (!wrap.children.length){
    wrap.innerHTML = '<div class="empty-grid">Nenhum item encontrado</div>';
  }
}

function onModelClick(cat, model) {
  state.selectedModel[cat.id] = model.id;
  // Aplica primeira variacao (texture 0) e mostra painel de cores
  const v = model.variations[0];
  applyVariation(cat, model, v);
  if (model.variations.length > 1) {
    openVariations(cat, model);
  } else {
    closeVariations();
  }
  renderItems();
}

function applyVariation(cat, model, v) {
  state.cart[cat.slot] = {
    modelId: model.id,
    itemId: model.id,
    nome: model.isNone ? model.nome : `${cat.label} ${pad(model.id)} · ${v.nome}`,
    preco: v.preco,
    drawable: v.drawable,
    texture: v.texture,
    mode: cat.mode,
    catLabel: cat.label,
  };
  post("preview", {
    slot: cat.slot, mode: cat.mode,
    drawable: v.drawable, texture: v.texture,
    preco: v.preco, nome: model.nome,
  });
  renderCart();
}

/* ---------- VARIACOES (CORES) ---------- */
function openVariations(cat, model) {
  const el = $("#variations");
  el.classList.remove("hidden");
  $("#varTitle").textContent = `${cat.label} ${pad(model.id)}`;
  const list = $("#varList");
  list.innerHTML = "";
  const cartEntry = state.cart[cat.slot];
  model.variations.forEach((v, i) => {
    const isActive = cartEntry && cartEntry.drawable === v.drawable && cartEntry.texture === v.texture;
    const item = document.createElement("div");
    item.className = "var-item" + (isActive ? " active" : "");
    const imgSrc = `images/${cat.slot}_${model.id}_${v.texture}.png`;
    item.innerHTML = `
      <div class="var-ico">
        <img src="${imgSrc}" onerror="this.style.display='none';this.nextElementSibling.style.display='block'" />
        <i class="${cat.icon}" style="display:none"></i>
      </div>
      <div class="var-info">
        <div class="var-name">Cor ${i+1}</div>
        <div class="var-price">${fmt(v.preco)}</div>
      </div>
    `;

    item.onclick = () => {
      applyVariation(cat, model, v);
      openVariations(cat, model);
    };
    list.appendChild(item);
  });
}
function closeVariations() {
  $("#variations").classList.add("hidden");
}

/* ---------- CARRINHO ---------- */
function renderCart() {
  const ul = $("#cartList");
  ul.innerHTML = "";
  const entries = Object.entries(state.cart);
  if (!entries.length) {
    ul.innerHTML = '<li class="empty">Nenhum item selecionado</li>';
    $("#total").textContent = "R$ 0";
    return;
  }
  let total = 0;
  entries.forEach(([slot, info]) => {
    total += info.preco || 0;
    const li = document.createElement("li");
    li.innerHTML = `<span class="nome">${info.catLabel} · ${info.nome.split('·').pop().trim()}</span><span class="preco">${fmt(info.preco)}</span>`;
    ul.appendChild(li);
  });
  $("#total").textContent = fmt(total);
}

/* ---------- EVENTOS ---------- */
window.addEventListener("message", (e) => {
  const d = e.data || {};
  if (d.action === "open") {
    state.categories = d.categories || [];
    state.currentCat = d.focus || (state.categories[0] && state.categories[0].id);
    state.cart = {};
    state.selectedModel = {};
    state.search = "";
    $("#search").value = "";
    closeVariations();
    $("#app").classList.remove("hidden");
    renderCategories();
    renderItems();
    renderCart();
  } else if (d.action === "close") {
    $("#app").classList.add("hidden");
  }
});

document.addEventListener("keydown", (e) => {
  if (e.key === "Escape") {
    if (!$("#variations").classList.contains("hidden")) {
      closeVariations();
      return;
    }
    post("cancel");
    $("#app").classList.add("hidden");
  }
});

$$(".rot-btns button").forEach(b => {
  b.onclick = () => post("rotate", { dir: b.dataset.dir });
});

$("#varBack").onclick = () => closeVariations();

$("#btnCancel").onclick = () => {
  post("cancel");
  $("#app").classList.add("hidden");
};

$("#btnBuy").onclick = async () => {
  const r = await post("buy");
  if (r && r.ok) {
    showToast(r.msg || "Compra concluída!", "ok");
    setTimeout(() => $("#app").classList.add("hidden"), 700);
  } else {
    showToast((r && r.msg) || "Falha na compra.", "err");
  }
};

$("#search").addEventListener("input", (e) => {
  state.search = e.target.value;
  renderItems();
});
